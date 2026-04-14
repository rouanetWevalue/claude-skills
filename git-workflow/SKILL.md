---
name: git-workflow
description: >
  Agent pour toutes les tâches de gestion de l'historique Git : nommage et cycle de vie des branches
  (Gitflow), rédaction et validation de commits (Conventional Commits / Gitmoji), création et
  description de Pull Requests / Merge Requests.
  UTILISER pour toute demande concernant une branche, un commit, une PR/MR, une revue de code,
  ou la stratégie de versioning.
---

# Git Workflow — Point d'entrée

## Étape 1 — Choisir le modèle

| Type de tâche | Modèle |
|---|---|
| Nommer une branche, rédiger un message de commit, créer une description de PR | `claude-haiku-4-5` |
| Décider comment découper une feature en branches ou PRs, stratégie de merge | `claude-sonnet-4-6` |

> En cas de doute → Haiku. Ces tâches sont mécaniques. Sonnet uniquement si une décision d'organisation est requise.

---

## Étape 2 — Charger la référence adaptée

| Contexte | Fichier à lire |
|---|---|
| Créer ou nommer une branche | `references/branches.md` |
| Rédiger ou valider un commit | `references/commits.md` |
| Créer, décrire ou merger une PR/MR | `references/pull-requests.md` |

> Charger uniquement la référence pertinente au contexte de la demande.

---

## Règles universelles

- **Pas de dérogation** : Claude applique les mêmes conventions que l'équipe, sans règle spécifique à son usage
- **Confirmer avant toute action irréversible** : suppression de branche, reset — résumer et attendre validation
