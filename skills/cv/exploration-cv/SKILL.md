---
name: exploration-cv
description: >
  Interview Socratique pour explorer et enrichir un profil normalisé (YAML issu
  de normalisation-profil). Pose des questions ciblées pour découvrir des
  réalisations non formulées, challenger les descriptions vagues, reformuler
  en format CAR (Contexte → Action → Résultat) et identifier les compétences
  implicites non déclarées. Produit un profil YAML enrichi, conforme au même
  schéma que l'entrée. UTILISER après normalisation-profil, avant scoring ou
  génération de CV.
---

# Exploration CV — Point d'entrée

## Étape 1 — Vérifier les inputs

L'entrée requise est un profil YAML normalisé, conforme au schéma défini dans
`normalisation-profil/references/schema.md`. Si le profil n'est pas encore
normalisé, invoquer le skill `normalisation-profil` d'abord.

Vérifier que le profil contient au minimum :
- `identite.nom` et `identite.prenom`
- Au moins une entrée dans `experiences[]`

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6` pour l'ensemble du skill.

> Règle : l'exploration exige du raisonnement interprétatif (détecter les vagues, reformuler en CAR, inférer des compétences implicites) — Haiku ne suffit pas.

## Étape 3 — Charger les références

Lire dans l'ordre :
1. `references/interview-soc.md` — protocole Socratique : signaux d'alarme, questions-types par champ du schéma, règles de conduite
2. `references/format-car.md` — définition CAR, exemples avant/après, règles de reformulation, extraction du champ `realisations[].metrique`

## Étape 4 — Analyser le profil avant d'interroger

Avant de poser la première question, parcourir le profil et dresser la liste des champs à enrichir :

| Signal d'alarme | Champ concerné | Priorité |
|---|---|---|
| Verbe vague dans `description` ou `realisations[].texte` | `realisations[]` | Haute |
| `realisations` vide ou `null` sur une expérience ≥ 1 an | `realisations[]` | Haute |
| `metrique: null` sur une réalisation avec résultat probable | `realisations[].metrique` | Haute |
| `competences[]` incomplet vs responsabilités listées | `competences[]` | Moyenne |
| `resume` absent, vide ou générique | `resume` | Moyenne |
| `certifications[]` vide pour un profil senior | `certifications[]` | Basse |

Présenter cette liste à l'utilisateur comme point de départ de l'interview.

## Étape 5 — Mener l'interview Socratique

Suivre le protocole de `references/interview-soc.md` :
- Une question à la fois, ciblée sur un champ précis
- Reformuler la réponse en CAR selon `references/format-car.md` avant d'injecter dans le profil
- Afficher après chaque échange : champs enrichis / champs encore à `null` / prochaine question

Critère d'arrêt : 3 échanges consécutifs sans nouvelle information sur un champ → passer au suivant.

## Étape 6 — Produire le profil enrichi

Sortie : bloc YAML fenced (` ```yaml … ``` `) contenant le profil mis à jour.
- Conserver **exactement** le schéma de `normalisation-profil/references/schema.md`
- N'ajouter aucun champ hors schéma
- Enrichir uniquement : `realisations[].texte`, `realisations[].metrique`, `competences[]`, `resume`
- Laisser à `null` tout champ non renseigné après l'interview

Ajouter un résumé en 3 bullets :
- Réalisations reformulées en CAR
- Compétences implicites ajoutées
- Champs restants à `null` (à explorer lors d'une prochaine session)
