# DONE — claude-skills-repo

<!--
Archives des tâches complétées. Format :
- [x] Description — [TAG] — PR #N — YYYY-MM-DD
-->

---

## 2026-04-15

### [ARCH] Architecture globale — restructuration repo (PR #6)

- [x] Définir la structure cible du repo : `skills/`, `hooks/`, `agents/`, `scripts/`, `.claude/` — [ARCH-REPO-STRUCT]
- [x] Migrer les skills existants sous `skills/` (dev/, content/, gestion/) et adapter les scripts de sync — [ARCH-MIGRATE-SKILLS]
- [x] Migrer les hooks utilisateur (`.claude/hooks/`) sous `hooks/claude/` et adapter les scripts — [ARCH-MIGRATE-HOOKS]
- [x] Créer la structure `agents/` et étendre `sync-to-claude.sh` pour synchroniser vers `~/.claude/agents/` — [ARCH-AGENTS-DIR]
- [x] Mettre à jour la CI pour valider la nouvelle structure (`skills/**/SKILL.md`, `skills/**/references/`) — [ARCH-CI]
- [x] Documenter la procédure d'onboarding complète dans README.md — [ARCH-ONBOARDING]

### [GITWF] Skill git-workflow — création (PRs #1–2)

- [x] Créer le skill `git-workflow` : branches, commits, PRs, revues — skill livré et synchronisé

### [GTODO] Skill gestion-todo — création (PR #1)

- [x] Créer le skill `gestion-todo` avec les 6 références (consult, edit, archive, triage, structure, config) — skill livré

### [SKILL-AUDIT] Règle d'audit skills publics (PR #7)

- [x] Ajouter la règle "Step 0 — Audit obligatoire" dans CLAUDE.md avant création/mise à jour majeure d'un skill

### [SKILL-BUILDER] Skill skill-builder — création (PR #8)

- [x] Créer le skill `skill-builder` : design, description-cso, references-format, checklist

### [NEW-ORCH] Skill orchestration-agents — création (PR #9)

- [x] Créer skill `orchestration-agents` : decomposition, decision-model, dispatch, config — [NEW-ORCH]

### [AGENT-REVIEWER] Agent task-reviewer — création (PR #9)

- [x] Créer agent `task-reviewer` : revue automatique conformité + qualité, rapport VALIDER/CORRIGER/BLOQUER — [AGENT-REVIEWER]

### [FIX] Hook skill-sync-reminder — fix Windows backslashes (PR #10)

- [x] Corriger la regex du hook `skill-sync-reminder.sh` : normaliser les backslashes Windows avant le test grep

### [HOOK-PROTECT-DEFAULT-BRANCH] Hook protect-main — branche par défaut générique (PR #13)

- [x] Remplacer la détection codée en dur (`main`) par `git symbolic-ref refs/remotes/origin/HEAD` avec fallback sur les noms courants (`master`, `trunk`, `develop`)

### [ARCH-GLOBAL-HOOKS] Hooks utilisateur globaux — généralisation (PR #12)

- [x] Déplacer `protect-main.sh` vers `hooks/user/` (synchronisé vers `~/.claude/hooks/`)
- [x] Déplacer `skill-sync-reminder.sh` vers `.claude/hooks/` (scope projet uniquement)
- [x] Étendre `sync-to-claude.sh` : copie `hooks/user/*.sh` → `~/.claude/hooks/` + fusion additive `~/.claude/settings.json`
- [x] Supprimer `hooks/claude/` — remplacé par `hooks/user/` + `.claude/hooks/`
- [x] Mettre à jour `README.md` et `CLAUDE.md` : documenter distinction hooks utilisateur vs projet
