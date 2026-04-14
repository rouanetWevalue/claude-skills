# Design — Skill `gestion-todo`

**Date :** 2026-04-14  
**Statut :** approuvé

---

## Objectif

Créer un skill `gestion-todo` qui guide Claude dans la gestion complète de TODOs dans n'importe quel projet utilisant un fichier `TODO.md`. Le format de référence est celui de wevalue-ai-lab, adaptable via une config projet `.claude/todo-config.md`.

---

## Architecture

```
gestion-todo/
├── SKILL.md
└── references/
    ├── consult.md      ← lire, résumer, session start
    ├── edit.md         ← ajouter, mettre à jour statuts
    ├── archive.md      ← archiver sections complètes → DONE.md
    ├── triage.md       ← réévaluer priorités sur événement
    ├── structure.md    ← hiérarchie, regroupement, découpage sous-fichiers
    └── config.md       ← initialiser/modifier .claude/todo-config.md
```

---

## SKILL.md — Router

### Étape 0 — Lire la config projet

Chercher `.claude/todo-config.md`. S'il existe, charger ses overrides. Sinon, appliquer les defaults wevalue-ai-lab.

### Étape 1 — Choisir le modèle

| Type de tâche | Modèle |
|---|---|
| Toutes les opérations courantes (lire, éditer, archiver, triage simple) | `claude-haiku-4-5` |
| Restructuration impliquant une décision d'organisation complexe | `claude-sonnet-4-6` |

### Étape 2 — Router par opération

| Contexte détecté | Référence |
|---|---|
| Résumer / lister TODOs ouverts, début de session | `references/consult.md` |
| Marquer `[x]`/`[~]`, ajouter un TODO | `references/edit.md` |
| Archiver une section complète vers `DONE.md` | `references/archive.md` |
| Réévaluer les priorités P0-P3 | `references/triage.md` |
| Organiser : hiérarchie, regroupement, découpage sous-fichiers | `references/structure.md` |
| Initialiser ou modifier la config projet | `references/config.md` |

### Règle universelle

Confirmer avant toute écriture, sauf si `auto_confirm: true` dans la config.

---

## `references/consult.md`

### Session start

Si `session_start_summary: true` (défaut) :
- Lire `TODO.md` et les sous-fichiers référencés s'ils existent
- Afficher un résumé structuré : total tâches ouvertes, regroupées par priorité P0 → P3, puis par section
- Signaler les sections entièrement `[x]` (archivables)

### Consultation explicite

- Même résumé que session start, invocable à tout moment
- Filtres disponibles : par priorité, par section, par statut (`[~]` uniquement)

### Format de sortie standardisé

```
## TODOs ouverts — YYYY-MM-DD

### P0 — Bloquant (N)
  [TAG] Tâche...

### P1 — Important (N)
  [TAG] Tâche...

### P2 — Sprint suivant (N)
### P3 — Backlog (N)

### Sections archivables
  [TAG] — toutes les tâches [x]
```

---

## `references/edit.md`

### Ajouter un TODO

- Format : `- [ ] Description — [TAG] Pniveau`
- Demander section cible, tag, priorité si non précisés
- Insérer à la bonne position (P0 avant P1, etc.) dans la section
- Si sous-fichiers existent : demander dans quel fichier insérer

### Mettre à jour le statut

| Transition | Action |
|---|---|
| → `[x]` | Ajouter date `(YYYY-MM-DD)` |
| → `[~]` | Ajouter note optionnelle `(en cours — contexte)` |
| → `[ ]` | Retour en ouvert (annulation) |

Après chaque passage à `[x]` : vérifier si la section est entièrement complète → déclencher la logique d'archivage si applicable.

### Convention inline dans le code (rappel si pertinent)

```
// TODO[TAG]: description — voir TODO.md#TAG
```

---

## `references/archive.md`

### Déclencheur

- `auto_archive: true` (défaut) : automatique quand toutes les tâches d'une section sont `[x]`
- `auto_archive: false` : signalement sans action, archivage sur demande explicite uniquement

### Procédure

1. Renommer le titre : ajouter ` — finalisé YYYY-MM-DD`
2. Déplacer le bloc entier (titre + tâches) dans `DONE.md`
3. Supprimer la section de `TODO.md`
4. Si section dans un sous-fichier référencé : supprimer la référence dans `TODO.md` et le bloc dans le sous-fichier (ou le sous-fichier entier s'il est vide)

Confirmation avant écriture sauf `auto_confirm: true`.

---

## `references/triage.md`

### Déclencheurs reconnus

- Ajout d'une nouvelle application ou fonctionnalité majeure
- Incident ou blocage en production
- Changement d'équipe significatif
- Demande explicite de l'utilisateur
- Événements custom configurés dans `triage_triggers`

### Procédure

1. Lister toutes les tâches `[ ]` et `[~]`
2. Proposer les réévaluations avec justification explicite
3. Présenter le delta complet (anciennes → nouvelles priorités) avant d'écrire
4. Attendre confirmation avant d'appliquer

### Règle anti-inflation P0

Ne pas dépasser 2-3 tâches P0 simultanément. Signaler si dépassé.

---

## `references/structure.md`

### Modèle de hiérarchie

```
TODO.md                        ← fichier principal (index si sous-fichiers)
  [SECTION-A]                  ← section thématique
      P0 — Bloquant
      P1 — Important
      P2 — Sprint suivant
      P3 — Backlog
  [ref] todo/infra.md          ← référence vers sous-fichier
  [ref] todo/agents.md
```

Les sous-fichiers suivent la même structure (sections → priorités). 2 niveaux recommandés, pas de limite de profondeur.

### Détection "fichier trop grand"

Seuil configurable `split_threshold` (défaut : 200 lignes).

| Config | Comportement |
|---|---|
| `disable_split_proposal: true` | Silence — ne jamais proposer |
| `auto_split: true` | Découpage automatique sans confirmation |
| défaut | Proposer le découpage avec règles suggérées |

### Procédure de découpage (quand proposé)

1. Analyser les sections existantes, suggérer des regroupements (par thème, domaine, équipe)
2. Présenter le plan : quels fichiers, quelles sections dedans
3. Attendre validation
4. Créer `todo/`, déplacer les sections, mettre à jour `TODO.md` avec les références `[ref]`

---

## `references/config.md`

### Initialisation

Si `.claude/todo-config.md` n'existe pas : le créer avec toutes les clés et leurs valeurs par défaut, commentaire explicatif pour chaque clé.

### Template par défaut

```markdown
# TODO Config

## Comportement général
auto_confirm: false           # skip confirmation avant écriture
session_start_summary: true   # résumé TODOs au démarrage de session

## Archivage
auto_archive: true            # archiver automatiquement les sections [x]

## Découpage
split_threshold: 200          # lignes avant proposition de découpage
auto_split: false             # découpage automatique sans proposition
disable_split_proposal: false # ne jamais proposer le découpage

## Triage
triage_triggers: []           # événements custom déclenchant un triage
                              # ex: ["nouvelle app", "incident prod"]

## Format (overrides du format wevalue-ai-lab)
todo_file: TODO.md
done_file: DONE.md
todo_dir: todo/
priorities: [P0, P1, P2, P3]
status_open: "[ ]"
status_inprogress: "[~]"
status_done: "[x]"
```

### Modification

Mettre à jour une ou plusieurs clés, confirmer avant d'écrire.
