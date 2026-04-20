---
name: generation-cv-latex
description: >
  Génère un CV au format LaTeX depuis un profil YAML normalisé.
  Supporte deux templates : AltaCV (moderne, bicolonne) ou moderncv
  (classique ou banking). Produit le fichier .tex complet, compilable
  avec MiKTeX via `pdflatex cv.tex`.
---

# Génération de CV LaTeX — Point d'entrée

## Modèle

**`claude-haiku-4-5`** — la tâche est mécanique : mapper les champs YAML
vers des macros LaTeX selon un template fixe. La sélection du template
ajoute un branchement mais pas de raisonnement éditorial.

---

## Étape 1 — Identifier le template cible

Avant de générer, demander le template si non précisé :

> "Quel template souhaitez-vous ?
> - **AltaCV** : moderne, bicolonne, idéal pour les profils tech/créatifs
> - **moderncv** : sobre, linéaire, idéal pour les profils corporate/conseil
>   (style `classic` ou `banking`)"

| Choix utilisateur | Référence à charger |
|---|---|
| AltaCV | `references/template-altacv.md` |
| moderncv (classic ou banking) | `references/template-moderncv.md` |

Charger **uniquement** la référence du template choisi.

---

## Étape 2 — Charger la référence adaptée

La référence contient :
- Le preamble complet (`\documentclass`, packages, couleurs, marges)
- Les macros disponibles pour chaque section du profil
- Un exemple de structure de document complet

---

## Étape 3 — Règles universelles

- **Entrée attendue** : profil YAML conforme au schéma `normalisation-profil/references/schema.md`
- **Sortie** : fichier `.tex` complet, entre triple backticks ` ```latex `
- Après le bloc `.tex`, toujours indiquer la commande de compilation :
  ```
  pdflatex cv.tex
  ```
  (MiKTeX requis — disponible sur Windows via miktex.org)
- **Caractères spéciaux LaTeX** : échapper `&`, `%`, `$`, `#`, `_`, `{`, `}`, `~`, `^`, `\`
- **Champ `null`** dans le profil → macro omise ou bloc commenté avec `% section vide`
- **Encodage** : toujours inclure `\usepackage[utf8]{inputenc}` et `\usepackage[T1]{fontenc}`
- Ne pas générer de fichier `.bib` ou `.sty` — uniquement le `.tex`
