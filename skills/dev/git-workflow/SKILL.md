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

| Type de tâche | Modèle | Raison |
|---|---|---|
| Nommer une branche, rédiger un message de commit, créer une description de PR | `claude-haiku-4-5` | Tâche mécanique, résultat prévisible |
| Décider comment découper une feature en branches ou PRs, stratégie de merge simple | `claude-sonnet-4-6` | Décision d'organisation non mécanique |
| Organiser ou traiter une revue de code | `claude-sonnet-4-6` | Arbitrage qualité, reformulation feedback |
| Évaluer si un scope est trop large, proposer un découpage en sous-scopes | `claude-opus-4-6` | Raisonnement architectural — une mauvaise coupe crée des dépendances impossibles |
| Décider l'ordre de merge entre worktrees, résoudre des conflits inter-branches | `claude-opus-4-6` | Optimisation multi-variables : criticité + cascade + impact croisé |

> En cas de doute → Sonnet. Opus uniquement quand la décision a un impact structurant sur l'architecture ou l'ordre des merges.

---

## Étape 2 — Charger la référence adaptée

| Contexte | Fichier à lire |
|---|---|
| Créer ou nommer une branche | `references/branches.md` |
| Rédiger ou valider un commit | `references/commits.md` |
| Créer, décrire ou merger une PR/MR | `references/pull-requests.md` |
| Organiser ou traiter une revue de code | `references/code-review-workflow.md` |
| Travailler sur plusieurs branches en parallèle (worktrees) | `references/worktree.md` |
| Décider comment publier des branches de worktrees, gérer dépendances ou conflits entre branches | `references/worktree-strategy.md` |

> Charger uniquement la référence pertinente au contexte de la demande.

---

## Règles universelles

- **Pas de dérogation** : Claude applique les mêmes conventions que l'équipe, sans règle spécifique à son usage
- **Confirmer avant toute action irréversible** : suppression de branche, reset — résumer et attendre validation
