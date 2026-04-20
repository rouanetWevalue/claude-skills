---
name: generation-cv-markdown
description: >
  Génère un CV au format Markdown depuis un profil YAML normalisé.
  Deux modes : CV classique (sections linéaires) ou CV orienté poste
  (highlights et réalisations mis en avant pour une offre cible).
  Produit un fichier Markdown prêt à être rendu ou converti.
---

# Génération de CV Markdown — Point d'entrée

## Modèle

**`claude-haiku-4-5`** — la tâche est mécanique : mapper les champs YAML vers
des sections Markdown selon un template fixe. Aucun raisonnement éditorial
n'est requis ; Haiku suffit pour la vitesse et le coût.

---

## Étape 1 — Identifier le mode de génération

Avant de générer, déterminer le mode :

| Signal dans la demande | Mode |
|---|---|
| Pas d'offre fournie, CV généraliste | **Classique** |
| Une offre d'emploi ou un poste cible est fourni | **Orienté poste** |

Si le mode n'est pas clair, poser la question :
> "Avez-vous une offre ou un poste cible ? Si oui, partagez-la pour personnaliser le CV."

---

## Étape 2 — Charger la référence

Charger `references/template.md` — ce fichier contient :
- Le template Markdown complet avec toutes les sections
- Les règles typographiques et de formatage
- Les exemples de bullets CAR pour les deux modes

---

## Étape 3 — Règles universelles

- **Entrée attendue** : profil YAML conforme au schéma `normalisation-profil/references/schema.md`
- **Ne jamais inventer** de données absentes du profil — laisser la section vide ou l'omettre
- **Champ `null`** dans le profil → section omise silencieusement (pas de placeholder)
- **Sortie** : bloc Markdown unique, prêt à copier-coller ou sauvegarder en `cv.md`
- **Mode orienté poste** : placer les réalisations les plus pertinentes en premier dans chaque expérience ; ajouter une section "Compétences clés pour le poste" juste après le résumé
- En cas d'ambiguïté sur l'ordre des sections, suivre l'ordre du template
