---
name: gestion-todo
description: >
  Agent pour la gestion complète des TODOs dans un projet : lecture et résumé des tâches ouvertes,
  ajout et mise à jour de statuts, archivage des sections complètes, réévaluation des priorités,
  organisation hiérarchique et découpage en sous-fichiers.
  Format de référence : TODO.md / DONE.md avec priorités P0-P3 et tags [TAG].
  Adaptable via .claude/todo-config.md dans le projet cible.
  UTILISER pour toute demande concernant les TODOs, le backlog, les priorités ou l'organisation
  des tâches d'un projet.
---

# Gestion TODO — Point d'entrée

## Étape 0 — Lire la config projet

Chercher `.claude/todo-config.md` à la racine du projet cible.
S'il existe, lire les overrides et les appliquer à toutes les étapes suivantes.
Sinon, utiliser les valeurs par défaut du format wevalue-ai-lab (voir `references/config.md`).

---

## Étape 1 — Choisir le modèle

| Type de tâche | Modèle |
|---|---|
| Toutes les opérations courantes (lire, éditer, archiver, triage) | `claude-haiku-4-5` |
| Restructuration avec décision d'organisation complexe (découpage sous-fichiers) | `claude-sonnet-4-6` |

> En cas de doute → Haiku. Sonnet uniquement si une décision d'architecture de fichiers est requise.

---

## Étape 2 — Router par opération

| Contexte détecté | Fichier à lire |
|---|---|
| Résumer / lister TODOs ouverts, début de session | `references/consult.md` |
| Marquer `[x]`/`[~]`, ajouter un TODO | `references/edit.md` |
| Archiver une section complète vers `DONE.md` | `references/archive.md` |
| Réévaluer les priorités P0-P3 | `references/triage.md` |
| Organiser : hiérarchie, regroupement, découpage sous-fichiers | `references/structure.md` |
| Initialiser ou modifier la config projet | `references/config.md` |

---

## Règle universelle

Confirmer avant toute écriture, sauf si `auto_confirm: true` dans la config.
