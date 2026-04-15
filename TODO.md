# TODO — claude-skills-repo

<!-- Format prérequis (optionnel) :
- [ ] Description de la tâche — [TAG] Pn
  needs: [AUTRE-TAG]
Une tâche est débloquée si elle n'a pas de `needs:` ou si tous les tags référencés sont [x].
-->

---

## [ARCH] architecture globale — skills, hooks & agents utilisateur

> Vision : ce repo devient le référentiel versionné de l'ensemble du profil Claude utilisateur.
> Trois catégories synchronisées vers `~/.claude/` : **skills**, **hooks**, **agents**.

- [ ] Définir la structure cible du repo : dossiers `skills/`, `hooks/`, `agents/` à la racine + `scripts/` + `.claude/` (settings projet uniquement) — [ARCH-REPO-STRUCT] P0
- [ ] Migrer les skills existants sous `skills/` et adapter `sync-to-claude.sh` / `sync-from-claude.sh` en conséquence — [ARCH-MIGRATE-SKILLS] P0
  needs: [ARCH-REPO-STRUCT]
- [ ] Migrer les hooks utilisateur (`.claude/hooks/`) sous `hooks/` et adapter les scripts de sync — [ARCH-MIGRATE-HOOKS] P0
  needs: [ARCH-REPO-STRUCT]
- [ ] Créer la structure `agents/` et étendre les scripts de sync pour synchroniser vers `~/.claude/agents/` — [ARCH-AGENTS-DIR] P0
  needs: [ARCH-REPO-STRUCT]
- [ ] Généraliser `protect-main` et `skill-sync-reminder` au niveau utilisateur (`~/.claude/settings.json`) pour couvrir tous les projets — [ARCH-GLOBAL-HOOKS] P0
  needs: [ARCH-MIGRATE-HOOKS]
- [ ] Mettre à jour la CI pour valider la nouvelle structure (`skills/*/SKILL.md`, `hooks/`, `agents/`) — [ARCH-CI] P1
  needs: [ARCH-MIGRATE-SKILLS]
- [ ] Documenter la procédure d'onboarding complète (clone → install-hooks → sync-to-claude → CLAUDE_SKILLS_PATH) — [ARCH-ONBOARDING] P1
  needs: [ARCH-GLOBAL-HOOKS]

---

## Skills

### [GTODO] gestion-todo — évolutions du skill

- [ ] Ajouter les blocs prérequis optionnels `needs: [TAG]` dans le format de tâche — [GTODO-FORMAT] P1
- [ ] Mettre à jour `references/consult.md` : afficher séparément les TODOs débloqués (sans needs ou needs tous [x]) — [GTODO-CONSULT] P1
  needs: [GTODO-FORMAT]
- [ ] Mettre à jour `references/edit.md` : documenter la syntaxe `needs:` — [GTODO-EDIT] P2
  needs: [GTODO-FORMAT]
- [ ] Ajouter Eisenhower matrix (urgence × importance) dans `references/triage.md` — [GTODO-EISENHOWER] P3
- [ ] Analyser les patterns des TODOs archivés (rétrospective DONE.md) dans `references/archive.md` — [GTODO-RETRO] P3

### [CAUTO] code-automation — améliorations

- [ ] Enrichir `references/tdd.md` : protocole red-green-refactor complet + test doubles — [CAUTO-TDD] P1
- [ ] Ajouter `references/lang-sql-postgres.md` : PostgreSQL best practices, indexing, migrations — [CAUTO-SQL] P2
- [ ] Ajouter `references/security-sast.md` : SAST, injection testing, OWASP top 10 — [CAUTO-SEC] P2
- [ ] Ajouter `references/frontend-artifacts.md` : génération HTML/React/Tailwind depuis description — [CAUTO-FRONT] P2
- [ ] Ajouter `references/lang-aws.md` : CDK, Lambda, microservices patterns — [CAUTO-AWS] P3
- [ ] Ajouter `references/serverless-agents.md` : patterns agents stateful, Cloudflare Durable Objects — [CAUTO-SERVERLESS] P3

### [RSYNTH] recherche-synthese — améliorations

- [ ] Ajouter `references/web-scraping.md` : intégration Firecrawl, extraction structurée depuis URLs — [RSYNTH-SCRAPING] P2
- [ ] Ajouter `references/recherche-academique.md` : protocole lit review → synthèse → conclusions — [RSYNTH-ACAD] P2
- [ ] Ajouter `references/fact-checking.md` : vérifier sources primaires, détecter biais et contradictions — [RSYNTH-FACT] P2
- [ ] Ajouter `references/veille-consolidation.md` : surveiller N sources, dédupliquer, agréger — [RSYNTH-VEILLE] P3

### [GPROJ] gestion-projet — améliorations

- [ ] Ajouter `references/strategie-produit.md` : OKRs, roadmap, discovery frameworks, métriques SaaS — [GPROJ-STRAT] P2
- [ ] Ajouter `references/meeting-insights.md` : extraire décisions, actions, contexte de réunions — [GPROJ-MEETING] P2
- [ ] Ajouter `references/linear.md` : gestion tickets Linear, workflows, intégration GitHub — [GPROJ-LINEAR] P3

### [REDAC] redaction — améliorations

- [ ] Ajouter `references/copywriting-persuasion.md` : frameworks AIDA, PAS, Before-After-Bridge — [REDAC-COPY] P2
- [ ] Ajouter `references/audit-contenu-ia.md` : détecter et réécrire patterns IA détectables — [REDAC-AUDIT] P3
- [ ] Ajouter `references/seo-content.md` : intégration keywords, structure SEO, schema markup — [REDAC-SEO] P3

### [ADOC] analyse-documents — améliorations

- [ ] Ajouter `references/analyse-contrats.md` : clauses clés, flags de risque, lecture légale — [ADOC-CONTRATS] P2
- [ ] Améliorer `references/multi-docs.md` : exemples de comparaisons contrastives détaillées — [ADOC-MULTI] P3

### [GITWF] git-workflow — améliorations

- [ ] Ajouter `references/code-review-workflow.md` : protocole demander + traiter une review — [GITWF-REVIEW] P2
- [ ] Ajouter `references/semver-changelog.md` : versioning sémantique, génération de CHANGELOG — [GITWF-SEMVER] P3

### [NEW] nouveaux skills à créer

- [ ] Créer skill `orchestration-agents` : dispatcher tâches parallèles, gérer dépendances entre agents — [NEW-ORCH] P1
- [ ] Créer skill `product-strategy` : OKRs, roadmap, frameworks PM, discovery, métriques — [NEW-PRODSTRAT] P2
  needs: [GPROJ-STRAT]
- [ ] Créer skill `security-testing` : SAST, fuzzing, DevSecOps, revue de sécurité — [NEW-SEC] P2
  needs: [CAUTO-SEC]
- [ ] Créer skill `academic-research` : pipeline complet recherche → lit review → synthèse — [NEW-ACAD] P3
  needs: [RSYNTH-ACAD]

---

## Agents

### [NEW-AGENTS] nouveaux agents à créer

> Les agents sont des instances Claude configurées (system prompt, outils, modèle) stockées dans `~/.claude/agents/`.
> Ils s'exécutent via la syntaxe `Agent(subagent_type: "nom-agent")`.

- [ ] Créer agent `code-reviewer` : review automatisée après implémentation d'un plan, vérifie conformité + qualité — [AGENT-REVIEWER] P1
  needs: [ARCH-AGENTS-DIR]
- [ ] Créer agent `pr-manager` : crée et gère les PRs en conformité avec git-workflow (branches, description, CI) — [AGENT-PR] P2
  needs: [ARCH-AGENTS-DIR]
- [ ] Créer agent `todo-analyst` : analyse les TODO.md, détecte les blocages, propose un ordre d'exécution — [AGENT-TODO] P2
  needs: [ARCH-AGENTS-DIR]

---

## Hooks

_(à venir — les items de migration des hooks sont dans [ARCH] ci-dessus)_
