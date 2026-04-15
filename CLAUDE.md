# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A versioned repository of the Claude user profile — skills, hooks, and agents organized around a **Progressive Disclosure** architecture. Skills are lightweight routers that conditionally load specialized reference files rather than monolithic prompts.

## Repository Structure

```
skills/
  dev/          → code-automation, git-workflow
  content/      → analyse-documents, recherche-synthese, redaction
  gestion/      → gestion-projet, gestion-todo

hooks/
  claude/       → Claude Code hooks (PostToolUse, PreToolUse) — referenced from .claude/settings.json
  git/          → git hooks installed via scripts/install-hooks.sh

agents/         → Claude agents (empty, future use)

scripts/        → sync-to-claude.sh, sync-from-claude.sh, install-hooks.sh
.claude/        → settings.json (project scope only, no hook files here)
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

- **Model stratification**: Haiku for extraction/CRUD, Sonnet for reasoning. Default to Sonnet when uncertain.
- **150-line hard limit** on all reference files — enforced by CI. If a reference grows beyond this, split it.
- **Language**: All skill content is written in French.
- **SKILL.md frontmatter**: Must include `name` and `description` YAML fields.
- **No executable code**: This repo contains only Markdown under `skills/`. References provide patterns and examples, not runnable scripts.
- **Rationale over rules**: Each routing decision in SKILL.md should explain *why* (e.g., "Haiku suffices because this is pure data extraction with no judgment").

## Adding or Modifying Skills

When creating a new skill:
1. Choose the right category: `skills/dev/`, `skills/content/`, or `skills/gestion/`
2. Create `skills/<category>/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`)
3. Write the router logic: task classification → model choice → reference loading
4. Add references under `skills/<category>/<skill-name>/references/` if needed, each under 150 lines
5. CI will validate structure automatically on push to `main`

When editing references, verify line count stays ≤ 150 (`wc -l references/your-file.md`).

## Adding or Modifying Hooks

- **Claude Code hooks** (PostToolUse, PreToolUse, etc.) go in `hooks/claude/` and must be referenced in `.claude/settings.json`
- **Git hooks** go in `hooks/git/` and are installed locally via `./scripts/install-hooks.sh`
