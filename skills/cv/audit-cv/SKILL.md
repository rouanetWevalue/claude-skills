---
name: audit-cv
description: >
  Évalue un CV classique sur 6 dimensions (structure, qualité descriptions, cohérence
  narrative, pertinence compétences, accroche, lisibilité). Prend en entrée un profil
  YAML normalisé (issu de normalisation-profil) et optionnellement un rapport
  analyse-marche-emploi. Produit un rapport audit_cv avec priorites[], consommable par
  optimisation-cv. UTILISER avant optimisation-cv pour un diagnostic approfondi, ou
  invoquer directement optimisation-cv si un audit séparé n'est pas nécessaire.
---

# Audit CV — Point d'entrée

## Étape 1 — Vérifier les inputs

**Input obligatoire :**
- Profil YAML normalisé conforme au schéma `normalisation-profil/references/schema.md`.
  Si absent → invoquer `normalisation-profil` d'abord.

**Input optionnel :**

| Input | Effet si absent |
|---|---|
| Rapport marché (`analyse-marche-emploi`) | Dimension 4 marquée `non_evalue` |

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6`.

> L'audit exige du jugement interprétatif (détecter les descriptions vagues, évaluer
> la cohérence narrative, identifier les compétences implicites) — Haiku ne suffit pas,
> Opus n'est pas nécessaire pour un profil unique.

## Étape 3 — Charger la référence

Lire `references/grille-audit-cv.md` — définit les 6 dimensions, indicateurs, niveaux
(OK/Faible/Critique) et le format de sortie.

## Étape 4 — Auditer dimension par dimension

Appliquer la grille de `references/grille-audit-cv.md` dans l'ordre :

| # | Dimension | Source dans le profil |
|---|---|---|
| 1 | Structure | Sections présentes, équilibre longueur |
| 2 | Qualité des descriptions | `experiences[].realisations[]` |
| 3 | Cohérence narrative | `resume` + `experiences[].poste` + `competences[]` |
| 4 | Pertinence compétences | `competences[]` vs rapport marché si dispo |
| 5 | Accroche/résumé | `identite.resume` |
| 6 | Lisibilité | Densité bullets, longueur descriptions |

Pour chaque dimension :
1. Relever les indicateurs présents ou absents
2. Appliquer les règles → attribuer `OK`, `Faible` ou `Critique`
3. Documenter les gaps (max 2 lignes par indicateur défaillant)

## Étape 5 — Produire la sortie

**Bloc 1 — YAML d'audit** (` ```yaml … ``` `) conforme au format de `references/grille-audit-cv.md` :
- `audit_cv.dimensions` : 6 entrées avec `statut` + `indicateurs_defaillants`
- `audit_cv.priorites` : top 3 actions pour `optimisation-cv`

**Bloc 2 — Synthèse en prose** (3-5 phrases) :
- Points forts et zones critiques dominantes
- Risque principal
- Recommandation : invoquer `optimisation-cv` avec ce rapport

## Règles universelles

- Ne jamais inventer de données absentes du profil YAML
- Distinguer gap structurel (champ absent) et gap qualitatif (champ présent mais insuffisant)
- Dimension 4 `non_evalue` si rapport marché absent — l'indiquer explicitement
