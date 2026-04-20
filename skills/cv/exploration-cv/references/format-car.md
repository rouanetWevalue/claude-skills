# Format CAR — Contexte → Action → Résultat

## Définition

Le format CAR structure chaque réalisation professionnelle en trois parties :

| Composant | Question | Ce qu'il contient |
|---|---|---|
| **Contexte** | Quelle était la situation ? | Environnement, contrainte, objectif initial, taille (équipe, budget, périmètre) |
| **Action** | Qu'avez-vous fait concrètement ? | Verbe fort, démarche précise, rôle exact (décideur / contributeur / leader) |
| **Résultat** | Quel impact mesurable ? | Métrique chiffrée, délai, comparatif avant/après, bénéficiaire |

> Le Résultat est la partie la plus critique : sans lui, le CAR est une simple description de tâche.

---

## Exemples avant / après

### Avant (description vague)
> "Participé à la refonte du système de reporting."

### Après (format CAR)
> "Face à un reporting mensuel manuel mobilisant 2 jours/ETP, piloté la refonte vers un tableau de bord Power BI automatisé, réduisant le temps de production de 85 % et permettant une actualisation quotidienne."

---

### Avant (absence de résultat)
> "Géré une équipe de développeurs sur le projet de migration cloud."

### Après (format CAR)
> "Dans le contexte d'une migration AWS pour 12 applications legacy (budget 400 k€), managé une équipe de 5 développeurs sur 8 mois, livrant le projet à -7 % vs budget initial avec zéro incident critique en production."

---

### Avant (verbe vague + pas de contexte)
> "Contribution aux ventes."

### Après (format CAR)
> "Sur un portefeuille PME en décroissance (-12 % N-1), déployé une stratégie de cross-sell sur les clients existants, générant 340 k€ de CA additionnel sur l'exercice (+22 % vs objectif)."

---

## Règles de reformulation

1. **Commencer par le contexte** — donner la situation avant l'action
2. **Verbe fort à la première personne** — "piloté", "conçu", "déployé", "réduit", "négocié" (pas "participé", "aidé")
3. **Quantifier systématiquement** — chercher : %, €, jours, personnes, NPS, délai, rang
4. **Préciser le rôle** — distinguer "décideur", "référent technique", "contributeur" pour éviter l'inflation
5. **Limiter à 2–3 phrases** — un CAR long perd son impact ; couper si > 60 mots

---

## Extraction de métriques — champ `realisations[].metrique`

Ce champ contient la métrique principale du Résultat, isolée du texte :

| Type | Exemples de valeur |
|---|---|
| Gain de temps | "-85 % de temps de traitement", "2 jours → 20 min" |
| Gain financier | "+340 k€ CA", "économie de 80 k€/an" |
| Croissance | "+22 % vs objectif", "×3 en 18 mois" |
| Volume | "12 applications migrées", "5 000 utilisateurs onboardés" |
| Délai | "livré en 8 mois vs 10 planifiés" |
| Qualité | "0 incident critique", "NPS +18 pts" |

Si aucune métrique n'est extractible après relance Socratique : `metrique: null` — ne pas inventer.

---

## Indicateur de qualité d'un CAR

Un CAR est complet si l'on peut répondre OUI à ces 3 questions :
- [ ] Le lecteur comprend-il la situation initiale sans contexte supplémentaire ?
- [ ] L'action décrit-elle ce que le candidat a fait (pas ce que l'équipe a fait) ?
- [ ] Le résultat est-il chiffré ou objectivement vérifiable ?
