---
name: scoring-pertinence-profil
description: >
  Score la pertinence d'un profil normalisé (YAML) par rapport à un segment de
  marché cible. Prend en entrée un profil normalisé (issu de normalisation-profil
  ou exploration-cv) et un rapport d'analyse marché (issu de analyse-marche-emploi).
  Produit un score global 0-100, des scores détaillés par dimension et les
  top 3 priorités d'amélioration actionnables. UTILISER pour tout diagnostic
  de positionnement profil/marché ou pour prioriser un plan d'optimisation CV.
---

# Scoring Pertinence Profil — Point d'entrée

## Étape 1 — Vérifier les inputs

Deux entrées sont requises :

1. **Profil normalisé** : YAML conforme au schéma `normalisation-profil/references/schema.md`.
   Si le profil n'est pas encore normalisé → invoquer `normalisation-profil` d'abord.
   Si le profil contient des réalisations vagues ou sans métriques → envisager `exploration-cv` avant de scorer.

2. **Rapport d'analyse marché** : rapport structuré produit par `analyse-marche-emploi`,
   contenant au minimum les sections §3 (compétences techniques), §4 (soft skills) et §6 (profil type).
   Si ce rapport est absent → invoquer `analyse-marche-emploi` d'abord.

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6` pour l'ensemble du skill.

> Règle : le scoring exige une analyse comparative croisée (profil vs marché sur 6 dimensions) avec pondérations et justifications — Haiku ne suffit pas, Opus n'est pas nécessaire pour un profil unique.

## Étape 3 — Charger la référence

Lire `references/grille-scoring.md` — définit les 6 dimensions, les pondérations, l'échelle 0-100 et les règles de notation pour chaque dimension.

## Étape 4 — Calculer les scores

Appliquer la grille de `references/grille-scoring.md` dimension par dimension :

| Dimension | Poids | Données profil | Données marché |
|---|---|---|---|
| Compétences techniques | 30 % | `competences[]` | Rapport §3 |
| Soft skills | 15 % | `competences[]` soft | Rapport §4 |
| Expérience | 25 % | `experiences[]` | Rapport §6 |
| Formation | 10 % | `formations[]` | Rapport §6 |
| Certifications | 10 % | `certifications[]` | Rapport §3 |
| Narrative / Positionnement | 10 % | `resume` + `realisations[]` | Rapport §1 |

Pour chaque dimension :
1. Relever les données disponibles dans le profil
2. Les comparer aux attentes du rapport marché
3. Appliquer les règles de notation de `references/grille-scoring.md`
4. Documenter la justification du score (max 1 ligne par dimension)

## Étape 5 — Identifier les top 3 priorités

Parmi les dimensions les moins bien scorées, sélectionner les 3 actions avec le meilleur rapport **impact sur le score / effort de mise en oeuvre** :

- Préférer les reformulations (effort faible, gain rapide) aux formations longues
- Préférer les certifications rapides aux reconversions sectorielles
- Mentionner l'effort estimé (ex : "1–2 h de reformulation", "2 mois de formation")

## Étape 6 — Produire la sortie

Sortie en deux blocs :

**Bloc 1 — YAML de scoring** (` ```yaml … ``` `) conforme au format défini dans `references/grille-scoring.md` :
- `score_global` (pondéré, arrondi à l'entier)
- `dimensions` (6 scores individuels)
- `top_3_priorites` (dimension, écart constaté, action recommandée)

**Bloc 2 — Synthèse en prose** (3–5 phrases) :
- Profil global (points forts et points faibles dominants)
- Risque principal identifié (ex : surqualification, compétence clé manquante)
- Recommandation de prochaine étape (quel skill invoquer : `exploration-cv`, `optimisation-linkedin`, `generation-cv-*`)

## Règles universelles

- **Ne jamais inventer** de données absentes du profil ou du rapport marché
- **Citer explicitement** chaque critère marché utilisé (ex : "compétence X indispensable selon rapport §3")
- **Ne pas scorer** si le rapport marché est incomplet (§3, §4 ou §6 manquants) — signaler le manque et demander de relancer `analyse-marche-emploi`
