# Commits — Conventions

## Format

```
type(scope): description courte

Corps optionnel — expliquer le POURQUOI, pas le quoi

Footer : refs ticket, breaking changes
```

**Gitmoji** peut remplacer `type` — deux formes acceptées :
- Emoji collé directement : `✨(auth): add user login`
- Code texte (saisie manuelle) : `:sparkles:(auth): add user login`

---

## Types Conventional Commits

| Type | Gitmoji | Usage |
|---|---|---|
| `feat` | ✨ `:sparkles:` | Nouvelle fonctionnalité |
| `fix` | 🐛 `:bug:` | Correction de bug |
| `docs` | 📝 `:memo:` | Documentation uniquement |
| `style` | 🎨 `:art:` | Formatage, sans changement logique |
| `refactor` | ♻️ `:recycle:` | Refactoring sans correction ni feature |
| `test` | ✅ `:white_check_mark:` | Ajout ou correction de tests |
| `chore` | 🔧 `:wrench:` | Maintenance, dépendances, configuration |
| `perf` | ⚡️ `:zap:` | Amélioration de performance |
| `ci` | 👷 `:construction_worker:` | Configuration CI/CD |

---

## Règle SRP — Un commit, un sujet

**Un commit = un sujet logique unique.**

Si des modifications portent sur plusieurs sujets distincts → les découper en commits séparés.

Raison : facilite la review sur les PRs importantes, rend l'historique lisible, permet un revert ciblé.

Exemples de découpage correct :
```
# ❌ À éviter
git commit -m "feat(auth): add login + fix typo in dashboard + update deps"

# ✅ Correct
git commit -m "feat(auth): add login flow"
git commit -m "fix(dashboard): fix label typo"
git commit -m "chore: update dependencies"
```

---

## Règles de forme

- Présent impératif : `add feature` — pas `added` ni `adding`
- Première ligne < 72 caractères
- Corps optionnel : expliquer le pourquoi, jamais le quoi

---

## Interdits

- Secrets ou credentials en clair
- Fichiers générés ou binaires lourds non nécessaires
- `--no-verify` : interdit sauf exception documentée explicitement dans le message de commit
