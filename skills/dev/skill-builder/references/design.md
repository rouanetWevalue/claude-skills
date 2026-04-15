# Conception d'un skill — routing et architecture

## Principe fondamental : Progressive Disclosure

Un skill n'est PAS un gros prompt. C'est un **routeur léger** qui charge conditionnellement
des fichiers spécialisés selon la tâche détectée.

```
SKILL.md  →  identifie la phase  →  charge references/[fichier].md correspondant
```

Si un SKILL.md contient de la logique métier, des exemples détaillés ou dépasse ~80 lignes :
c'est un signe qu'il fait le travail d'une référence. Extraire dans `references/`.

---

## Structure obligatoire du SKILL.md

```
---
name: nom-du-skill
description: >
  [description CSO — voir references/description-cso.md]
---

# Nom — Point d'entrée

## Étape 0 — [Pré-requis projet si pertinent]
## Étape 1 — Choisir le modèle
## Étape 2 — Router par opération
## Règle universelle
```

---

## Stratégie de routing modèle

| Tâche | Modèle | Critère |
|---|---|---|
| Extraction, transformation, CRUD, remplissage template | `claude-haiku-4-5` | Aucun jugement requis — résultat prévisible |
| Analyse, conception, raisonnement, nouvelle architecture | `claude-sonnet-4-6` | Décision non mécanique, arbitrage requis |
| Doute | `claude-sonnet-4-6` | Par défaut — le coût de l'erreur est plus élevé |

**Règle de décision** : poser la question — "Peut-on écrire un test unitaire déterministe
pour ce résultat ?" Si oui → Haiku. Si non → Sonnet.

---

## Concevoir le tableau de routing (Étape 2)

Chaque ligne du tableau = un contexte détectable + un fichier de référence.
Le contexte doit être formulé comme une **intention observable**, pas un mot-clé.

| À faire | À éviter |
|---|---|
| "Ajouter une tâche, modifier un statut" | "édition" (trop vague) |
| "Réévaluer les priorités P0-P3" | "priorités" |
| "Archiver une section vers DONE.md" | "archive" |

**Nombre de références recommandé : 3–6.** En dessous de 3 : le skill est peut-être trop simple
pour justifier une architecture références. Au-delà de 6 : envisager de le découper en 2 skills.

---

## Nommage du skill et des références

- **Skill** : kebab-case, verbe-sujet ou domaine-action (`gestion-todo`, `code-automation`, `skill-builder`)
- **Catégorie** : `skills/dev/`, `skills/content/`, `skills/gestion/` selon le domaine
- **Références** : nom du concept couvert, sans redondance avec le dossier parent (`design.md`, pas `skill-design.md`)

---

## Anti-patterns à éviter

| Anti-pattern | Problème | Correction |
|---|---|---|
| Logique métier dans SKILL.md | Charge toujours tout le contexte | Extraire dans references/ |
| Un skill pour tout | Routing trop large, précision perdue | Découper par domaine |
| References/ > 150 lignes | CI échoue + lecture difficile | Scinder en 2 fichiers thématiques |
| Description = résumé du skill | Jamais invoqué par le moteur | Voir references/description-cso.md |
| Exemple unique dans SKILL.md | Pas de couverture des edge cases | Déplacer dans references/ avec variantes |
