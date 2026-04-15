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
│   │   ├── recherche-synthese/ ← Veille, recherche web, comparaisons
│   │   └── redaction/          ← Emails, rapports, documentation
│   └── gestion/
│       ├── gestion-projet/     ← Notion, Slack, tâches, suivi
│       └── gestion-todo/       ← Lecture, édition, triage, archivage TODO.md
├── hooks/
│   ├── claude/                 ← Hooks Claude Code (PostToolUse, PreToolUse)
│   │   ├── protect-main.sh     ← Bloque les push directs sur main
│   │   └── skill-sync-reminder.sh  ← Rappel sync après modif skill
│   └── git/                    ← Hooks git locaux
│       └── pre-push            ← Vérifie qu'on ne pousse pas sur main
├── agents/                     ← Agents Claude (à venir)
├── scripts/
│   ├── sync-to-claude.sh       ← Pousse skills → profil local
│   ├── sync-from-claude.sh     ← Importe skills ← profil local
│   └── install-hooks.sh        ← Installe les hooks git dans .git/hooks/
├── .claude/
│   └── settings.json           ← Hooks Claude Code (scope projet)
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
| `content` | `analyse-documents` | Haiku / Sonnet | Extraction, synthèse, Q&A sur documents |
| `content` | `recherche-synthese` | Haiku / Sonnet | Veille, recherche web, comparaisons |
| `content` | `redaction` | Sonnet | Emails, rapports, documentation |
| `gestion` | `gestion-projet` | Haiku / Sonnet | Notion, Slack, tâches, suivi |
| `gestion` | `gestion-todo` | Haiku / Sonnet | Lecture, édition, triage, archivage TODO.md |

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

# 3. Synchroniser les skills vers le profil local Claude
export CLAUDE_SKILLS_PATH=~/.claude/skills
./scripts/sync-to-claude.sh
```

## Synchronisation

```bash
# Repo → profil local
./scripts/sync-to-claude.sh

# Profil local → repo (met à jour les skills existants en place)
./scripts/sync-from-claude.sh
```
