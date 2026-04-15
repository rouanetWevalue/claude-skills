---
name: code-automation
description: >
  Agent pour toutes les tâches de développement et d'automatisation : nouveaux scripts,
  debug/refacto, APIs, Infrastructure as Code (Terraform, Helm, K8s), pipelines CI/CD,
  automatisations shell, adaptation de maquettes Figma.
  Langages : JavaScript/Node.js, Python, Bash/Shell, HCL, YAML, JSON, Dockerfile, HTML/Jinja2, CSS.
  UTILISER pour toute demande contenant du code, une config, une spec technique,
  un TODO technique, une maquette à implémenter, ou un besoin d'automatisation.
---

# Code & Automation — Point d'entrée

## Étape 1 — Choisir le modèle

| Complexité | Critères | Modèle |
|---|---|---|
| **Simple** | Transform YAML/JSON, snippet <30 lignes, reformatage, Dockerfile cosmétique | `claude-haiku-4-5` |
| **Standard** | Script autonome, refacto ciblée, config infra connue, pipeline CI/CD classique, debug d'erreur claire | `claude-sonnet-4-6` |
| **Complexe** | Nouvelle architecture, debug multi-fichiers ambigu, système distribué, adaptation maquette complète | `claude-sonnet-4-6` |

> En cas de doute → Sonnet. Haiku uniquement si la tâche est mécaniquement triviale.

---

## Étape 2 — Identifier le contexte et charger les références

### Par type de tâche

| Contexte | Fichier à lire |
|---|---|
| Nouveau projet / nouvelle fonctionnalité significative | `references/architecture.md` |
| Debug ou refactoring | `references/debug-refacto.md` |
| Toute implémentation | `references/tdd.md` |

### Par langage détecté

| Langage | Fichier à lire |
|---|---|
| JavaScript / Node.js / TypeScript | `references/lang-javascript.md` |
| Bash / Shell | `references/lang-bash.md` |
| HCL / Terraform | `references/lang-hcl.md` |
| YAML / K8s / Helm | `references/lang-yaml.md` |
| CI/CD (GitHub Actions, GitLab CI, pipelines) | `references/lang-yaml-cicd.md` |
| Python | `references/lang-python.md` |
| Dockerfile | `references/lang-docker.md` |
| HTML / CSS / Jinja2 | `references/lang-web.md` |

> Charger uniquement les fichiers pertinents. Si plusieurs langages sont impliqués, charger chaque référence concernée.

---

## Étape 3 — Appliquer

Suivre les instructions du ou des fichiers de référence chargés. Les standards `tdd.md` s'appliquent à tout code testable, quelle que soit la tâche.
