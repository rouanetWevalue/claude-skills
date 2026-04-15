# Sécurité & SAST

Référence appliquée lors d'une revue de sécurité, d'un audit de code,
ou de toute implémentation exposée à des entrées externes.

---

## OWASP Top 10 — Correspondances code

| Risque | Pattern dangereux | Mitigation |
|---|---|---|
| A01 Broken Access Control | Autorisation côté client, URL directes | Vérifier les droits côté serveur à chaque requête |
| A02 Cryptographic Failures | MD5/SHA1, secrets en dur, HTTP | TLS, bcrypt/Argon2, variables d'environnement |
| A03 Injection | Concaténation SQL/shell, `eval()` | Requêtes paramétrées, whitelist d'inputs |
| A04 Insecure Design | Pas de rate limiting, logique métier contournable | Modéliser les menaces dès la conception |
| A05 Security Misconfiguration | CORS `*`, debug en prod, headers absents | CORS strict, désactiver debug, headers sécurité |
| A06 Vulnerable Components | Dépendances non mises à jour | `npm audit`, `pip-audit`, Dependabot |
| A07 Auth Failures | Sessions infinies, pas de lockout | Expiration, MFA, lockout après N échecs |
| A08 Integrity Failures | Désérialisation non vérifiée, CI sans signature | Vérifier checksums, signer les artefacts |
| A09 Logging Failures | Pas de logs ou logs avec données sensibles | Logger les événements sécurité, masquer PII |
| A10 SSRF | URL construite depuis input utilisateur | Whitelist domaines, bloquer les IPs internes |

---

## Injection — Patterns à détecter et corriger

### SQL Injection
```python
# DANGEREUX
query = f"SELECT * FROM users WHERE id = {user_id}"

# SÛR
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

### Command Injection
```python
# DANGEREUX
os.system(f"ping {host}")
subprocess.run(f"ls {path}", shell=True)

# SÛR
subprocess.run(["ping", host])
subprocess.run(["ls", path])  # shell=False par défaut
```

### XSS (Cross-Site Scripting)
```javascript
// DANGEREUX
element.innerHTML = userInput

// SÛR
element.textContent = userInput          // texte brut
DOMPurify.sanitize(userInput)           // si HTML nécessaire
```

---

## Checklist de revue sécurité

**Inputs**
- [ ] Toute entrée externe validée (type, longueur, format, charset)
- [ ] Paramètres SQL/NoSQL toujours paramétrés, jamais concaténés
- [ ] Uploads : vérifier type MIME réel + extension + taille max

**Authentification & Autorisation**
- [ ] Vérification des droits côté serveur (jamais côté client seul)
- [ ] Tokens avec expiration, rotation après login
- [ ] Pas de secrets dans les logs, les URLs ni le code source

**Configuration**
- [ ] Variables d'environnement pour tous les secrets
- [ ] Headers HTTP sécurité présents (`CSP`, `HSTS`, `X-Frame-Options`)
- [ ] CORS restrictif — pas de `*` en production
- [ ] Mode debug désactivé en production

**Dépendances**
- [ ] Audit des dépendances (`npm audit --audit-level=high`, `pip-audit`)
- [ ] Pas de dépendances abandonnées ou sans mainteneur actif
