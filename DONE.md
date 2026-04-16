# DONE — claude-skills-repo

<!--
Archives des tâches complétées. Format :
- [x] Description — [TAG] — PR #N — YYYY-MM-DD
-->

---

## 2026-04-16

### Nouveaux skills + refactor gestion-projet (PR #17)

- [x] Créer skill `analyse-reunion` : analyse transcripts de réunion (résumé, décisions, actions owner+deadline, dynamiques de communication) — Haiku/Sonnet/Opus
- [x] Créer skill `gestion-notion` : opérations Notion via MCP (pages CRUD, databases, blocs, recherche) — Haiku/Sonnet
- [x] Refactorer `gestion-projet` : retirer Notion du scope (Option B), rediriger vers `gestion-notion` — [GPROJ-MEETING] superseded
- [x] Mettre à jour CLAUDE.md : tableau des skills + 3 nouveaux items TODO (ARCH-MCP-CONFIG, NEW-SLACK-PUSH, NEW-SCOPE-GUARD)

---

## 2026-04-15

### [CAUTO] code-automation — TDD, sécurité, frontend (PR #15)

- [x] Enrichir `references/tdd.md` : cycle red-green-refactor détaillé + section test doubles (Stub/Mock/Spy/Fake/Dummy) — [CAUTO-TDD]
- [x] Créer `references/security-sast.md` : OWASP Top 10 mappé sur patterns code, injection SQL/command/XSS, checklist revue sécurité — [CAUTO-SEC]
- [x] Créer `references/frontend-artifacts.md` : workflow description→artefact, React patterns, Tailwind courants, accessibilité — [CAUTO-FRONT]
- [x] Mettre à jour `SKILL.md` : routing vers `security-sast.md` et `frontend-artifacts.md`

### [GTODO] gestion-todo — évolutions du skill (PR #14)

- [x] Ajouter syntaxe `needs: [TAG]` dans `references/edit.md` : format, règles débloqué/bloqué — [GTODO-FORMAT] [GTODO-EDIT]
- [x] Mettre à jour `references/consult.md` : section "Débloqués — à traiter" + marqueur ⛔ pour tâches bloquées — [GTODO-CONSULT]
- [x] Ajouter matrice Eisenhower dans `references/triage.md` — [GTODO-EISENHOWER]
- [x] Ajouter protocole rétrospective DONE.md dans `references/archive.md` — [GTODO-RETRO]

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
