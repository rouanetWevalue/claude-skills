---
name: normalisation-profil
description: >
  Convertit toute donnée brute de profil professionnel (issue de extraction-pdf,
  extraction-docx, extraction-linkedin, ou saisie manuelle) vers le schéma YAML
  standard normalisé. Produit le profil normalisé utilisé par tous les autres
  skills CV : exploration-cv, scoring-pertinence-profil, generation-cv-*.
  UTILISER dès qu'une extraction brute doit être structurée pour un traitement aval.
---

# Normalisation de Profil — Point d'entrée

## Étape 1 — Choisir le modèle

| Qualité de l'input | Modèle |
|---|---|
| Extraction propre et structurée (champs déjà identifiés) | `claude-haiku-4-5` |
| Texte brut avec ambiguïtés, lacunes ou inférences nécessaires | `claude-sonnet-4-6` |

> Règle : si l'input contient des champs mal délimités, des dates incomplètes ou des compétences implicites à inférer → Sonnet.

## Étape 2 — Charger le schéma

Lire `references/schema.md` — c'est la définition du schéma cible. La normalisation produit **toujours** ce schéma complet.

## Étape 3 — Normaliser

1. **Mapper** chaque champ de l'input vers le champ schéma correspondant
2. **Inférer** les champs implicites (type_contrat, niveau de compétence, métriques) depuis le contexte
3. **Mettre `null`** pour tout champ absent — ne jamais inventer
4. **Standardiser** les dates au format `YYYY-MM`
5. **Convertir** les réalisations en format CAR si elles ne le sont pas déjà

## Étape 4 — Valider

Vérifier que le YAML produit :
- [ ] Contient tous les champs de premier niveau du schéma (même à `null`)
- [ ] N'a aucun champ inventé absent de la source
- [ ] `meta.source` est renseigné
- [ ] Les dates sont au format `YYYY-MM`

## Sortie

Bloc YAML fenced (` ```yaml … ``` `) avec le profil normalisé complet.
Ajouter un résumé en 3 bullets : champs bien remplis / champs inférés / champs manquants.
