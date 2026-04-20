---
name: audit-profil-linkedin
description: >
  Audite un profil LinkedIn normalisé (YAML issu de normalisation-profil) en
  identifiant les gaps, zones faibles et incohérences de narrative.
  Prend en entrée : un profil normalisé YAML (obligatoire), un rapport
  scoring-pertinence-profil (optionnel), un rapport analyse-marche-emploi (optionnel).
  Produit un rapport d'audit structuré sur 6 dimensions : complétude, qualité des
  descriptions, cohérence narrative, pertinence compétences, headline/résumé,
  signaux LinkedIn. Ce rapport sert de base à optimisation-linkedin.
  UTILISER avant toute optimisation LinkedIn ou reformulation de profil.
---

# Audit Profil LinkedIn — Point d'entrée

## Étape 1 — Vérifier les inputs

**Input obligatoire :**

- **Profil normalisé YAML** conforme au schéma `normalisation-profil/references/schema.md`.
  Si absent → invoquer `normalisation-profil` d'abord.

**Inputs optionnels :**

- **Rapport scoring-pertinence-profil** : active la dimension 4 (pertinence compétences vs marché).
  Si absent → dimension 4 marquée `non_evalue` dans le rapport d'audit.
- **Rapport analyse-marche-emploi** : enrichit les dimensions 4 et 3 (narrative vs attentes marché).
  Si absent → analyse basée uniquement sur les données internes du profil.

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6` pour l'ensemble du skill.

> Règle : l'audit exige du jugement interprétatif (identifier des incohérences de narrative,
> évaluer l'impact d'un headline, détecter des vides qualitatifs) — Haiku ne suffit pas,
> Opus n'est pas nécessaire pour un profil unique sans décision architecturale.

## Étape 3 — Charger la référence

Lire `references/grille-audit.md` — définit les 6 dimensions d'audit, les indicateurs,
les niveaux OK/Faible/Critique et le format de sortie du rapport.

## Étape 4 — Auditer dimension par dimension

Appliquer la grille de `references/grille-audit.md` en séquence :

| # | Dimension | Source dans le profil | Source externe |
|---|---|---|---|
| 1 | Complétude | Tous les champs du schéma | — |
| 2 | Qualité des descriptions d'expérience | `experiences[].realisations[]` | — |
| 3 | Cohérence de la narrative | `resume` + `experiences[].poste` + `competences[]` | Rapport marché §1 si dispo |
| 4 | Pertinence des compétences vs marché | `competences[]` | Rapport scoring (dimensions 1-2) |
| 5 | Headline et résumé | `identite.titre` + `resume` | — |
| 6 | Signaux LinkedIn spécifiques | `identite.linkedin_url` + données déclaratives | À vérifier manuellement |

Pour chaque dimension :
1. Relever les indicateurs présents (ou absents) dans le profil
2. Appliquer les règles de la grille → attribuer un niveau : `OK`, `Faible` ou `Critique`
3. Documenter les gaps constatés (max 2 lignes par indicateur défaillant)

## Étape 5 — Produire la sortie

Sortie en deux blocs :

**Bloc 1 — YAML d'audit** (` ```yaml … ``` `) conforme au format défini dans
`references/grille-audit.md` :
- `audit.dimensions` : 6 entrées avec `statut`, `indicateurs_defaillants`, `gaps`
- `audit.priorites` : top 3 actions pour `optimisation-linkedin` (impact / effort)

**Bloc 2 — Synthèse en prose** (3–5 phrases) :
- Profil global : points forts et zones critiques dominantes
- Risque principal (ex : narrative incohérente, profil vide, compétences non documentées)
- Recommandation de prochaine étape : invoquer `optimisation-linkedin` avec ce rapport

## Règles universelles

- **Ne jamais inventer** de données absentes du profil YAML — signaler explicitement les `null`
- **Distinguer** gap structurel (champ absent) et gap qualitatif (champ présent mais insuffisant)
- **Dimension 4 non évaluée** si le rapport scoring est absent — l'indiquer explicitement, ne pas approximer
- **Dimension 6** partiellement évaluable depuis le YAML — signaler les signaux nécessitant une vérification manuelle sur LinkedIn
