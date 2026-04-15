# Dockerfile

---

## Principes

- **Tag fixe** : jamais `FROM node:latest` — toujours `FROM node:20-alpine`
- **Multi-stage** : séparer build et runtime pour minimiser l'image finale
- **Non-root** : toujours terminer avec un user non-root
- **COPY ciblé** : ne pas copier ce qui n'est pas nécessaire au runtime
- **Layer caching** : copier les fichiers de dépendances avant le code source

---

## Template Node.js (multi-stage)

```dockerfile
# ── Build stage ──────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Dépendances d'abord (cache layer)
COPY package*.json ./
RUN npm ci --only=production

# Code source ensuite
COPY src/ ./src/

# ── Runtime stage ────────────────────────────────────────
FROM node:20-alpine AS runtime

WORKDIR /app

# Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copier uniquement ce dont on a besoin
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src

# Variables d'environnement non-secrètes
ENV NODE_ENV=production \
    PORT=3000

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
```

---

## Template Python (multi-stage)

```dockerfile
FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt

FROM python:3.12-slim AS runtime

WORKDIR /app

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY --from=builder /app/deps /app/deps
COPY src/ ./src/

ENV PYTHONPATH=/app/deps \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER appuser

CMD ["python", "src/main.py"]
```

---

## .dockerignore (toujours inclure)

```
.git
.env
.env.*
node_modules
__pycache__
*.pyc
*.log
dist/
build/
coverage/
.DS_Store
README.md
```

---

## Checklist

- [ ] Image de base avec tag fixe (version + variant)
- [ ] Multi-stage si build nécessaire
- [ ] Dépendances copiées avant le code source
- [ ] `.dockerignore` présent
- [ ] User non-root en dernière couche
- [ ] `HEALTHCHECK` défini
- [ ] Pas de secrets dans les `ENV` ou les layers
- [ ] `EXPOSE` documenté
