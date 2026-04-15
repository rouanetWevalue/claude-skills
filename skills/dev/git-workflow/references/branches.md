# Branches — Conventions Gitflow

## Stratégie : Gitflow

| Branche | Rôle | Créée depuis | Merge vers |
|---|---|---|---|
| `main` | Code en production | — | — |
| `develop` | Intégration continue | — | — |
| `feature/*` | Nouvelle fonctionnalité | `develop` | `develop` |
| `release/*` | Préparation de release | `develop` | `main` + `develop` |
| `hotfix/*` | Correctif urgent en production | `main` | `main` + `develop` |

Supprimer la branche après merge.

---

## Nommage

**Format préféré** (lorsqu'un ticket existe — à utiliser chaque fois que possible) :
```
type/TICKET-description-courte
```
Exemples : `feat/PROJ-42-user-auth`, `fix/PROJ-18-login-timeout`, `hotfix/PROJ-99-null-pointer`

**Format alternatif** (sans ticket associé) :
```
type/description-courte
```
Exemples : `feat/user-auth`, `chore/update-deps`, `docs/api-readme`

**Règles de forme :**
- Kebab-case, minuscules uniquement, pas d'espaces
- Types autorisés : `feat`, `fix`, `chore`, `refactor`, `docs`, `hotfix`, `release`

---

## Branches protégées : `main` et `develop`

Les règles suivantes s'appliquent sans exception :

- Aucun push direct (`git push`)
- Aucun force push (`git push --force`)
- Passage obligatoire par Pull Request / Merge Request
- Conditions requises avant merge :
  - CI en succès
  - Au moins 1 approbation humaine
