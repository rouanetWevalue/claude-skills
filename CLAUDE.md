# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A versioned repository of the Claude user profile — skills, hooks, and agents organized around a **Progressive Disclosure** architecture. Skills are lightweight routers that conditionally load specialized reference files rather than monolithic prompts.

## Repository Structure

```
skills/
  dev/          → code-automation, git-workflow, skill-builder, orchestration-agents
  content/      → analyse-documents, recherche-synthese, redaction
  gestion/      → gestion-projet, gestion-todo

hooks/
  user/         → Claude Code hooks synced to ~/.claude/hooks/ (all projects)
  git/          → git hooks installed via scripts/install-hooks.sh

agents/
  task-reviewer/ → post-implementation review: conformity + quality

scripts/        → sync-to-claude.sh (skills+hooks+agents), sync-from-claude.sh, install-hooks.sh
.claude/
  hooks/        → project-only Claude Code hooks (never synced to user profile)
  settings.json → project-scope hooks config
```

## Validation

Validation runs via GitHub Actions (`.github/workflows/validate.yml`) and checks two rules:
1. Every skill directory must contain a `SKILL.md`
2. Every file under `references/` must be ≤ 150 lines

To sync skills to the Claude Code environment:
```bash
./scripts/sync-to-claude.sh
```

## Architecture

Each skill follows this layout:
```
skill-name/
├── SKILL.md          ← Router: task classification, model selection, reference loading
└── references/       ← Specialized context files loaded conditionally by SKILL.md
    └── [context].md
```

**SKILL.md is a decision tree**, not a full prompt. It:
1. Identifies the task type from user input
2. Chooses Claude Haiku (mechanical/CRUD tasks) or Claude Sonnet (reasoning/analysis)
3. Loads only the relevant reference files for that task

**References** are ~50–150 line files, each covering exactly one concept (language, pattern, or tool). They are appended to the prompt only when relevant — never all at once.

### Current Skills

| Category | Skill | Domain |
|---|---|---|
| `dev` | `code-automation` | Dev, scripts, APIs, IaC, CI/CD |
| `dev` | `git-workflow` | Branches, commits, PRs, reviews |
| `content` | `analyse-documents` | PDF/report extraction, synthesis, comparison |
| `content` | `recherche-synthese` | Web research, benchmarking, competitive analysis |
| `content` | `redaction` | Emails, reports, documentation |
| `gestion` | `gestion-projet` | Notion/Slack workflows, task tracking |
| `gestion` | `gestion-todo` | TODO.md read, edit, triage, archive |

## Key Conventions

- **Model stratification**: Haiku (extraction/CRUD) → Sonnet (reasoning/analysis) → Opus (high-stakes judgment: architecture, decomposition, multi-doc synthesis, risk analysis). Default to Sonnet when uncertain.
- **150-line hard limit** on all reference files — enforced by CI. If a reference grows beyond this, split it.
- **Language**: All skill content is written in French.
- **SKILL.md frontmatter**: Must include `name` and `description` YAML fields.
- **No executable code**: This repo contains only Markdown under `skills/`. References provide patterns and examples, not runnable scripts.
- **Rationale over rules**: Each routing decision in SKILL.md should explain *why* (e.g., "Haiku suffices because this is pure data extraction with no judgment").

## Adding or Modifying Skills

### Step 0 — Audit des skills publics existants (OBLIGATOIRE)

**Déclencheur** : création initiale d'un skill OU mise à jour majeure (nouveau domaine, refonte du routing, ajout de plusieurs références).

Avant toute conception ou implémentation, effectuer un audit des skills publics traitant du même sujet ou d'un sujet proche. L'objectif est d'identifier les approches existantes et les points couverts par la communauté que la demande initiale aurait omis.

**Sources à consulter :**
- Anthropic Marketplace (claude.ai/marketplace ou MCP `mcp__claude_ai_Canva` si disponible)
- GitHub — collections de skills communautaires, notamment :
  - https://github.com/abubakarsiddik31/claude-skills-collection
  - Recherche GitHub : `"SKILL.md" <topic>` ou `claude skills <topic>`
- Autres dépôts publics ou articles de blog recensés lors de la recherche

**Livrable de l'audit** (à présenter à l'utilisateur avant de passer à la conception) :

1. **Tableau des approches constatées** — pour chaque skill trouvé : source, routing choisi (modèles), références principales, particularité notable
2. **Points majeurs ou edge cases non couverts** — fonctionnalités, cas limites ou patterns traités par des skills existants et absents de la demande initiale de l'utilisateur
3. **Recommandation** — approche préconisée parmi les options observées, avec justification

L'utilisateur valide (ou amende) cet audit avant que la conception (spec + plan) ne commence.

### Étapes suivantes (après validation de l'audit)

1. Choose the right category: `skills/dev/`, `skills/content/`, or `skills/gestion/`
2. Create `skills/<category>/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
3. Write the router logic: task classification → model choice → reference loading
4. Add references under `skills/<category>/<skill-name>/references/` if needed, each under 150 lines
5. CI will validate structure automatically on push to `main`

When editing references, verify line count stays ≤ 150 (`wc -l references/your-file.md`).

## Adding or Modifying Hooks

Deux types de hooks coexistent dans ce repo — ne pas les confondre :

| Dossier | Scope | Synchronisation |
|---|---|---|
| `hooks/user/` | Utilisateur global — s'applique à **tous** les projets | Copié vers `~/.claude/hooks/` + enregistré dans `~/.claude/settings.json` via `sync-to-claude.sh` |
| `.claude/hooks/` | Projet uniquement — ne sort jamais de ce repo | Référencé dans `.claude/settings.json` (scope projet) |
| `hooks/git/` | Hooks git locaux | Installés dans `.git/hooks/` via `./scripts/install-hooks.sh` |

**Règle** : un hook qui référence des chemins ou des conventions propres à ce repo (`./scripts/`, `skills/`, `agents/`) **ne peut pas** être un hook utilisateur — il appartient à `.claude/hooks/`.

### Enregistrement automatique des hooks utilisateur

Lors de l'exécution de `./scripts/sync-to-claude.sh`, chaque fichier `.sh` dans `hooks/user/` est :
1. Copié dans `~/.claude/hooks/`
2. Enregistré comme entrée `PreToolUse` (matcher `Bash`) dans `~/.claude/settings.json` via une fusion additive (les entrées existantes ne sont jamais écrasées)

## Closing a Branch (OBLIGATOIRE avant PR)

Avant d'ouvrir une PR ou de déclarer un travail terminé, vérifier systématiquement :

1. **TODO.md** — marquer `[x]` toutes les tâches réalisées dans cette branche
2. **DONE.md** — archiver les items `[x]` avec la date et le numéro de PR
   - Si une section de TODO.md est entièrement `[x]` → déplacer la section complète dans DONE.md
   - Sinon → lister les items individuels dans DONE.md sous la date du jour
3. **README.md / CLAUDE.md** — mettre à jour si la structure, les conventions ou les workflows ont changé

> Ces trois points sont toujours requis. Ne pas les sauter même pour une "petite PR".
