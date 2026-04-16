# claude-skills

Référentiel versionné du profil Claude utilisateur — architecture Progressive Disclosure.
Trois catégories synchronisées vers `~/.claude/` : **skills**, **hooks**, **agents**.

## Structure

```
claude-skills-repo/
├── skills/
│   ├── dev/
│   │   ├── code-automation/    ← Dev, scripts, debug, IaC, CI/CD
│   │   └── git-workflow/       ← Branches, commits, PRs, revues
│   ├── content/
│   │   ├── analyse-documents/  ← Extraction, synthèse, Q&A sur documents
│   │   ├── analyse-reunion/    ← Analyse de transcripts : résumé, actions, dynamiques
│   │   ├── recherche-synthese/ ← Veille, recherche web, comparaisons
│   │   └── redaction/          ← Emails, rapports, documentation
│   └── gestion/
│       ├── gestion-notion/     ← Opérations Notion via MCP : pages, databases, blocs
│       ├── gestion-projet/     ← Slack, suivi projet, comptes rendus (Notion → gestion-notion)
│       └── gestion-todo/       ← Lecture, édition, triage, archivage TODO.md
├── hooks/
│   ├── user/                   ← Hooks Claude Code synchronisés vers ~/.claude/hooks/
│   │   └── protect-main.sh     ← Bloque les push directs sur main (tous projets)
│   └── git/                    ← Hooks git locaux
│       └── pre-push            ← Vérifie qu'on ne pousse pas sur main
├── agents/
│   └── task-reviewer/          ← Revue automatique conformité + qualité
│       └── AGENT.md
├── scripts/
│   ├── sync-to-claude.sh       ← Pousse skills, hooks, agents → ~/.claude/
│   ├── sync-from-claude.sh     ← Importe skills ← profil local
│   └── install-hooks.sh        ← Installe les hooks git dans .git/hooks/
├── .claude/
│   ├── hooks/
│   │   └── skill-sync-reminder.sh  ← Hook projet uniquement (non synchronisé)
│   └── settings.json           ← Hooks Claude Code (scope projet uniquement)
└── .github/
    └── workflows/validate.yml  ← CI : SKILL.md + limite 150 lignes
```

Chaque skill suit ce modèle :

```
skill-name/
├── SKILL.md          ← Routeur : classification tâche, choix modèle, chargement références
└── references/       ← Fichiers spécialisés, chargés uniquement si pertinents
    └── [contexte].md
```

## Skills disponibles

| Catégorie | Skill | Modèle | Description |
|---|---|---|---|
| `dev` | `code-automation` | Sonnet / Haiku | Dev, scripts, debug, IaC, CI/CD |
| `dev` | `git-workflow` | Haiku / Sonnet | Branches, commits, PRs, revues |
| `dev` | `skill-builder` | Sonnet | Conception et création de nouveaux skills |
| `dev` | `orchestration-agents` | Sonnet / Opus | Décomposition et dispatch de tâches en parallèle |
| `content` | `analyse-documents` | Haiku / Sonnet | Extraction, synthèse, Q&A sur documents |
| `content` | `analyse-reunion` | Haiku / Sonnet / Opus | Analyse transcripts : résumé, décisions, actions, dynamiques |
| `content` | `recherche-synthese` | Haiku / Sonnet | Veille, recherche web, comparaisons |
| `content` | `redaction` | Sonnet | Emails, rapports, documentation |
| `gestion` | `gestion-notion` | Haiku / Sonnet | Opérations Notion via MCP : pages, databases, blocs, recherche |
| `gestion` | `gestion-projet` | Haiku / Sonnet / Opus | Slack, suivi projet, comptes rendus (Notion → gestion-notion) |
| `gestion` | `gestion-todo` | Haiku / Sonnet | Lecture, édition, triage, archivage TODO.md |

## Agents disponibles

| Agent | Modèle | Description |
|---|---|---|
| `task-reviewer` | Sonnet | Revue automatique conformité plan + qualité code |

## Règle de routing

- **Haiku** : tâche mécanique, extraction, CRUD, transform, snippet court
- **Sonnet** : raisonnement, analyse, nouvelle architecture, debug complexe
- **Doute** → Sonnet

## Principes

- `SKILL.md` = routeur léger, pas de logique métier
- Fichiers `references/` < 150 lignes chacun (enforced by CI)
- Chaque décision de routing a un rationnel explicite
- Architecture conçue pour évoluer, pas de sur-spécification

## Installation

```bash
# 1. Cloner le repo
git clone <url> && cd claude-skills-repo

# 2. Installer les hooks git (protection branche main)
./scripts/install-hooks.sh

# 3. Synchroniser skills, hooks et agents vers le profil local Claude
./scripts/sync-to-claude.sh
```

`sync-to-claude.sh` copie :
- `skills/**/` → `~/.claude/skills/`
- `agents/**/AGENT.md` → `~/.claude/agents/<nom>.md`
- `hooks/user/*.sh` → `~/.claude/hooks/` **et** enregistre automatiquement une entrée `PreToolUse` dans `~/.claude/settings.json`

## Synchronisation

```bash
# Repo → profil local
./scripts/sync-to-claude.sh

# Profil local → repo (met à jour les skills existants en place)
./scripts/sync-from-claude.sh
```
