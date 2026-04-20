---
name: analyse-marche-emploi
description: >
  Analyse le marché de l'emploi pour un poste et secteur cibles : benchmark
  salarial, compétences les plus demandées (techniques et comportementales),
  technologies en croissance ou déclin, tendances de recrutement.
  Produit un rapport structuré utilisé par scoring-pertinence-profil et
  optimisation-linkedin. UTILISER pour toute question de positionnement
  marché, benchmark salaire, ou identification des compétences à valoriser.
---

# Analyse Marché de l'Emploi — Point d'entrée

## Étape 1 — Collecter le contexte

Demander à l'utilisateur si non fourni :
1. **Poste cible** : intitulé exact ou approximatif
2. **Secteur** : industrie, type de structure (startup / grand groupe / conseil / public)
3. **Localisation** : ville, région ou "France entière"
4. **Niveau d'expérience** : junior / confirmé / senior (années)
5. **Contexte** : recherche active, benchmark interne, reconversion ?

## Étape 2 — Choisir le modèle

| Tâche | Modèle |
|---|---|
| Recherche web + extraction de données brutes | `claude-haiku-4-5` via `recherche-synthese` |
| Synthèse, interprétation des tendances, recommandations | `claude-sonnet-4-6` |
| Analyse multi-secteurs ou reconversion complexe | `claude-opus-4-6` |

## Étape 3 — Charger les références

1. Lire `references/sources.md` — liste des sources à consulter et requêtes types
2. Lire `references/analyse.md` — structure du rapport et règles de rédaction

## Étape 4 — Produire l'analyse

Utiliser le skill `recherche-synthese` pour les recherches web.
Structurer la sortie selon `references/analyse.md` (6 sections + Top 3 quick wins).

## Règles universelles

- **Citer toutes les sources** avec date — ne jamais présenter une donnée comme factuelle sans source
- **Dater l'analyse** : préciser "données collectées le [date]"
- **Distinguer** France vs région si la localisation est spécifique
- **Signaler** si les données ont plus de 12 mois (fiabilité réduite)
