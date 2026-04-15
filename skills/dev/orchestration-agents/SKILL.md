---
name: orchestration-agents
description: >
  Use when dispatching multiple tasks to subagents in parallel or in sequence.
  Triggers: "dispatcher des tâches", "agents parallèles", "orchestration", "paralléliser",
  "sous-agents", "parallel tasks", "multi-agent", "décomposer en tâches", "fan-out",
  "lancer plusieurs agents", "traiter en parallèle", "orchestration d'agents".
  Couvre : décomposition d'un problème, décision séquentiel/parallèle (multi-étapes),
  dispatch et collecte des résultats, revue automatique bypassable.
  Types supportés : investigation, implémentation de feature, correction d'anomalie, audit de code.
  NE PAS utiliser pour une tâche unique sans parallélisme — utiliser le skill métier directement.
---

# Orchestration Agents — Point d'entrée

## Étape 0 — Lire la config

Chercher dans cet ordre (le second override le premier) :
1. `~/.claude/orchestration-config.md` (config utilisateur)
2. `.claude/orchestration-config.md` (config projet)

Appliquer les overrides trouvés. Sinon, utiliser les valeurs par défaut (voir `references/config.md`).

---

## Étape 1 — Choisir le modèle selon la phase

| Phase | Modèle | Raison |
|---|---|---|
| Décomposition + modèle de décision | `claude-sonnet-4-6` | Jugement non mécanique requis |
| Dispatch tâche mécanique (extraction, CRUD, script) | `claude-haiku-4-5` | Résultat prévisible |
| Dispatch tâche complexe (architecture, refonte) | `claude-opus-4-6` | Raisonnement poussé |
| Revue automatique | Agent `task-reviewer` | Contexte frais, jugement isolé |

---

## Étape 2 — Router par phase

| Phase détectée | Fichier à lire |
|---|---|
| Décomposer un problème en tâches atomiques | `references/decomposition.md` |
| Construire le plan d'exécution (séquentiel / parallèle / multi-étapes) | `references/decision-model.md` |
| Dispatcher les agents, collecter et intégrer les résultats | `references/dispatch.md` |
| Configurer le comportement (bypass, limites, modèles) | `references/config.md` |

---

## Règle universelle

Valider avec l'utilisateur après la décomposition et après la revue automatique,
sauf `auto_confirm: true` dans la config ou bypass explicite au lancement.
