# DONE — claude-skills-repo

<!--
Archives des tâches complétées. Format :
- [x] Description — [TAG] — PR #N — YYYY-MM-DD
-->

---

## 2026-04-22

### [CV] Pipeline CV classique — 3 nouveaux skills (PR #TBD)

- [x] Créer skill `audit-cv` — audit CV classique 6 dimensions, rapport `audit_cv` avec priorites[]
- [x] Créer skill `optimisation-cv` — point d'entrée naturel, réécriture CAR, accroche, YAML enrichi
- [x] Créer skill `ciblage-cv` — ciblage offre emploi, scoring pertinence, réordonnancement YAML ciblé
- [x] Mettre à jour `CLAUDE.md` — tableau Current Skills

---

## 2026-04-20

### [CV] Pipeline complet d'optimisation de profil LinkedIn — 14 skills (PR #TBD)

Audit public réalisé en amont. Architecture en 4 batches (dépendances respectées). MiKTeX installé. MCP Playwright enregistré.

**Couche 1 — Extraction (content/)**
- [x] Créer skill `extraction-pdf` : extraction générique depuis tout PDF → schéma normalisé
- [x] Créer skill `extraction-docx` : extraction générique depuis DOCX/PPT → schéma normalisé

**Couche 2 — Normalisation + Extraction LinkedIn (cv/)**
- [x] Créer skill `normalisation-profil` : schéma YAML standard commun à tous les skills CV
- [x] Créer skill `extraction-linkedin` : copier/coller principal, URL via Playwright sur demande explicite uniquement

**Couche 3 — Analyse (cv/)**
- [x] Créer skill `exploration-cv` : interview Socratique, challenge expériences, format CAR
- [x] Créer skill `analyse-marche-emploi` : benchmark salaires, tendances tech, demande marché (via recherche-synthese)
- [x] Créer skill `scoring-pertinence-profil` : grille 6 dimensions, score 0-100 vs marché

**Couche 4 — Optimisation (cv/)**
- [x] Créer skill `audit-profil-linkedin` : 6 dimensions (complétude, CAR, narrative, pertinence, headline, signaux)
- [x] Créer skill `optimisation-linkedin` : réécriture sections (headline 3 variantes, about, expériences CAR, skills ATS)

**Couche 5 — Génération (cv/)**
- [x] Créer skill `generation-cv-markdown` : CV Markdown, mode classique et orienté poste
- [x] Créer skill `generation-cv-latex` : CV LaTeX (AltaCV ou moderncv)
- [x] Créer skill `generation-cv-docx` : CV DOCX via python-docx (script Python complet)
- [x] Créer skill `generation-cv-ppt` : profil 1-pager PPT via python-pptx (3 slides)
- [x] Créer skill `generation-cv-pdf` : orchestration LaTeX→PDF ou DOCX→PDF

**Infrastructure**
- [x] Créer `mcps/` + `scripts/install-mcps.sh` : gestion des MCP servers via CLI Claude Code — [ARCH-MCP-CONFIG]
- [x] Enregistrer MCP Playwright (scope utilisateur global) pour extraction LinkedIn via URL
- [x] Installer MiKTeX (LaTeX) pour `generation-cv-latex` et `generation-cv-pdf`
- [x] Mettre à jour README.md : section Prérequis (Python, LaTeX, Node) + MCPs + tableau 24 skills
- [x] Mettre à jour CLAUDE.md : table Current Skills complète (14 nouveaux skills)

### [CONTENT] Copywriting, SEO, Medium et LinkedIn — 4 skills + MCP medium (PR #TBD)

- [x] Créer skill `copywriting` : rédaction persuasive standalone (AIDA, PAS, BAB, FAB, analyse + anti-patterns) — [REDAC-COPY] superseded
- [x] Créer skill `seo-content` : optimisation SEO éditoriale standalone (on-page, structure, featured snippets, schema markup) — [REDAC-SEO] superseded
- [x] Créer skill `redaction-article` : pipeline complet articles Medium (format, publication MCP + fallback manuel) — orchestre `copywriting` et `seo-content`
- [x] Créer skill `redaction-linkedin-post` : posts LinkedIn feed (format, hooks, algorithme, adaptation d'articles)
- [x] Créer `mcps/medium.json` : MCP medium-mcp-server (Playwright-based, jackyckma/medium-mcp-server)
- [x] Mettre à jour `mcps/README.md` : ajouter entrée MCP `medium`
- [x] Mettre à jour `README.md` : 4 nouveaux skills dans le tableau + `medium-mcp-server` dans Prérequis + structure répertoires
- [x] Mettre à jour `CLAUDE.md` : 4 nouveaux skills dans le tableau Current Skills
- [x] Mettre à jour `TODO.md` : marquer [x] [REDAC-COPY] et [REDAC-SEO] (superseded par skills standalone)

---

## 2026-04-16 (2)

### [GITWF] git-workflow — code-review-workflow + worktree (PR #19)

- [x] Ajouter `references/code-review-workflow.md` : protocole équipe qui surcharge superpowers:requesting/receiving-code-review — 4 niveaux sévérité, anti-sycophanie, IaC/YAML, draft→ready, désaccord reviewer — [GITWF-REVIEW]
- [x] Ajouter `references/worktree.md` : travail multi-branches humain, convention anti-collision `.worktrees/` (humain) vs `.claude/worktrees/` (agent réservé) — [GITWF-WORKTREE]
- [x] Ajouter `references/worktree-strategy.md` : règle de scope, schéma `.worktree-config.md` (arbre N-niveaux, bidirectionnel), règle PR cascadante, configuration scope-split (ask/always/never), résolution conflits par impact — [GITWF-WORKTREE-STRAT]

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
