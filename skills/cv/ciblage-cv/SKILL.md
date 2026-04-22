---
name: ciblage-cv
description: >
  Adapte un CV pour une offre d'emploi spécifique. Accepte un YAML normalisé ou enrichi
  (issu de optimisation-cv) et un texte d'offre d'emploi. Invocable par "cible mon CV
  pour cette offre", "adapte mon CV pour [poste]", "optimise mon CV pour cette annonce".
  Si un CV brut est fourni à la place d'un YAML, orchestre normalisation + optimisation d'abord.
  Produit un bloc YAML ciblé distinct du YAML source et un résumé structuré des adaptations.
---

# Ciblage CV — Point d'entrée

## Étape 1 — Vérifier les inputs

**Inputs obligatoires :**
- CV source : YAML normalisé/enrichi, ou CV brut (texte/DOCX/PDF)
- Offre d'emploi : texte complet (coller l'annonce dans la conversation)

**Si CV brut fourni :**
Invoquer `normalisation-profil` (+ `extraction-docx` ou `extraction-pdf` si fichier),
puis `optimisation-cv`, puis reprendre ici avec le YAML enrichi produit.

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6`.

> Le ciblage exige d'analyser l'offre, de scorer chaque expérience et de reformuler
> le résumé — tâche de raisonnement multi-sources qui exclut Haiku.

## Étape 3 — Charger la référence

Lire `references/analyse-offre.md` — extraction mots-clés, scoring pertinence,
règles de réordonnancement, reformulation du résumé pour le poste cible.

## Étape 4 — Analyser l'offre

Appliquer §1 de `references/analyse-offre.md` :
1. Extraire `must_have[]`, `nice_to_have[]`, `keywords[]`, `secteur`, `ton`
2. Identifier le niveau de séniorité attendu
3. Normaliser les termes techniques selon le vocabulaire exact de l'offre

## Étape 5 — Scorer et réordonner

Appliquer §2 et §3 de `references/analyse-offre.md` :
1. Attribuer un score (0–3) à chaque expérience et réalisation
2. Réordonner `experiences[]` et `realisations[]` par pertinence décroissante
3. Réordonner `competences[]` pour mettre les `must_have` en premier
4. Ajouter dans `competences[]` les termes de l'offre présents dans les expériences
   mais absents de la liste

## Étape 6 — Reformuler le résumé

Appliquer §4 de `references/analyse-offre.md` :
- Ligne 1 : intitulé aligné sur l'offre + années d'expérience pertinente
- Ligne 2 : valeur principale vs `must_have` de l'offre (avec métrique si possible)
- Ligne 3 : angle différenciant non spécifié dans l'offre

## Étape 7 — Produire la sortie

**Bloc 1 — YAML ciblé** (` ```yaml … ``` `) :
- Même schéma que le YAML source
- `experiences[]` et `realisations[]` réordonnées
- `identite.resume` reformulé pour le poste
- `competences[]` réordonnées et enrichies
- `meta.cible: { poste, entreprise, date }` ajouté au bloc `meta` existant

**Bloc 2 — Résumé des adaptations** conforme au format `adaptations:` de
`references/analyse-offre.md` §5

## Règles universelles

- Ne jamais supprimer d'expériences — réordonner uniquement
- Ne jamais inventer de compétences absentes du profil source
- Signaler si le profil couvre < 60 % des `must_have` — le candidat doit en être informé
- Proposer la suite : "Pour générer le DOCX ciblé → `generation-cv-docx`"
