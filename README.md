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
│   │   ├── extraction-docx/    ← Extraction générique depuis DOCX/PPT (générique)
│   │   ├── extraction-pdf/     ← Extraction générique depuis PDF (générique)
│   │   ├── recherche-synthese/ ← Veille, recherche web, comparaisons
│   │   └── redaction/          ← Emails, rapports, documentation
│   ├── gestion/
│   │   ├── gestion-notion/     ← Opérations Notion via MCP : pages, databases, blocs
│   │   ├── gestion-projet/     ← Slack, suivi projet, comptes rendus (Notion → gestion-notion)
│   │   └── gestion-todo/       ← Lecture, édition, triage, archivage TODO.md
│   └── cv/
│       ├── normalisation-profil/   ← Conversion vers schéma profil standard YAML
│       ├── extraction-linkedin/    ← Extraction profil LinkedIn (copier/coller ou URL)
│       ├── exploration-cv/         ← Interview Socratique, challenge expériences, CAR
│       ├── analyse-marche-emploi/  ← Benchmark salaires, tendances tech, demande marché
│       ├── scoring-pertinence-profil/ ← Score profil vs segment marché cible
│       ├── audit-profil-linkedin/  ← Gaps, zones faibles, incohérences narrative
│       ├── optimisation-linkedin/  ← Réécriture sections LinkedIn
│       ├── generation-cv-markdown/ ← Génération CV Markdown
│       ├── generation-cv-latex/    ← Génération CV LaTeX
│       ├── generation-cv-docx/     ← Génération CV DOCX (python-docx)
│       ├── generation-cv-ppt/      ← Génération présentation profil PPT (python-pptx)
│       └── generation-cv-pdf/      ← Génération CV PDF (LaTeX ou DOCX→PDF)
├── mcps/
│   ├── README.md               ← Liste des MCPs et instructions d'installation
│   └── playwright.json         ← Config MCP Playwright (browser automation)
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
│   ├── install-hooks.sh        ← Installe les hooks git dans .git/hooks/
│   └── install-mcps.sh         ← Installe les MCPs via claude mcp add
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
| `dev` | `git-workflow` | Haiku / Sonnet | Branches, commits, PRs, revues de code, worktrees |
| `dev` | `skill-builder` | Sonnet | Conception et création de nouveaux skills |
| `dev` | `orchestration-agents` | Sonnet / Opus | Décomposition et dispatch de tâches en parallèle |
| `content` | `analyse-documents` | Haiku / Sonnet | Extraction, synthèse, Q&A sur documents |
| `content` | `analyse-reunion` | Haiku / Sonnet / Opus | Analyse transcripts : résumé, décisions, actions, dynamiques |
| `content` | `extraction-pdf` | Haiku | Extraction générique de données structurées depuis PDF |
| `content` | `extraction-docx` | Haiku | Extraction générique de données structurées depuis DOCX/PPT |
| `content` | `recherche-synthese` | Haiku / Sonnet | Veille, recherche web, comparaisons |
| `content` | `redaction` | Sonnet | Emails, rapports, documentation |
| `gestion` | `gestion-notion` | Haiku / Sonnet | Opérations Notion via MCP : pages, databases, blocs, recherche |
| `gestion` | `gestion-projet` | Haiku / Sonnet / Opus | Slack, suivi projet, comptes rendus (Notion → gestion-notion) |
| `gestion` | `gestion-todo` | Haiku / Sonnet | Lecture, édition, triage, archivage TODO.md |
| `cv` | `normalisation-profil` | Haiku / Sonnet | Conversion extraction brute → schéma profil YAML standard |
| `cv` | `extraction-linkedin` | Haiku | Extraction profil LinkedIn (copier/coller principal, URL sur demande) |
| `cv` | `exploration-cv` | Sonnet | Interview Socratique, challenge expériences, extraction CAR |
| `cv` | `analyse-marche-emploi` | Sonnet | Benchmark salaires, tendances tech, demande marché emploi |
| `cv` | `scoring-pertinence-profil` | Sonnet | Score profil vs segment marché cible |
| `cv` | `audit-profil-linkedin` | Sonnet | Gaps, zones faibles, incohérences de narrative |
| `cv` | `optimisation-linkedin` | Sonnet | Réécriture sections LinkedIn (orchestre `redaction`) |
| `cv` | `generation-cv-markdown` | Haiku | Génération CV au format Markdown |
| `cv` | `generation-cv-latex` | Haiku | Génération CV au format LaTeX |
| `cv` | `generation-cv-docx` | Haiku | Génération CV DOCX via python-docx |
| `cv` | `generation-cv-ppt` | Haiku | Génération présentation profil PPT via python-pptx |
| `cv` | `generation-cv-pdf` | Haiku | Génération CV PDF (via LaTeX ou DOCX→PDF) |

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

## Prérequis

| Prérequis | Version | Requis par |
|---|---|---|
| Python | 3.x | `generation-cv-docx`, `generation-cv-ppt`, `generation-cv-pdf` |
| `python-docx` | `pip install python-docx` | `generation-cv-docx`, `generation-cv-pdf` |
| `python-pptx` | `pip install python-pptx` | `generation-cv-ppt` |
| `docx2pdf` | `pip install docx2pdf` | `generation-cv-pdf` (chemin DOCX→PDF) |
| MiKTeX / TeX Live | dernière version | `generation-cv-latex`, `generation-cv-pdf` (chemin LaTeX) |
| Node.js + npx | v18+ | `extraction-linkedin` (MCP Playwright, chemin URL uniquement) |
| Claude Code CLI | dernière version | `scripts/install-mcps.sh` |
| `jq` | v1.6+ | `scripts/install-mcps.sh` |

## MCPs

Les MCP servers étendent les capacités de Claude (browser automation, etc.).
Voir [`mcps/README.md`](mcps/README.md) pour la liste complète.

```bash
# Installer les MCPs définis dans mcps/
./scripts/install-mcps.sh
```

## Installation

```bash
# 1. Cloner le repo
git clone <url> && cd claude-skills-repo

# 2. Installer les hooks git (protection branche main)
./scripts/install-hooks.sh

# 3. Synchroniser skills, hooks et agents vers le profil local Claude
./scripts/sync-to-claude.sh

# 4. (Optionnel) Installer les MCPs
./scripts/install-mcps.sh
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
