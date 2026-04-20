---
name: generation-cv-pdf
description: >
  Orchestre la génération d'un CV au format PDF depuis un .tex ou un .docx existant,
  ou oriente vers le skill de génération adapté si aucun fichier source n'est disponible.
  Chemin A : compiler un .tex avec pdflatex/xelatex (MiKTeX sur Windows).
  Chemin B : convertir un .docx en PDF avec docx2pdf (Python, requiert Word).
  UTILISER pour toute demande de production d'un PDF de CV, quel que soit le point de départ.
---

# Génération de CV PDF — Point d'entrée

## Modèle

**`claude-haiku-4-5`** — orchestration mécanique : détecter le fichier source disponible
et générer les commandes de compilation ou de conversion. Aucun raisonnement éditorial requis.

---

## Étape 1 — Identifier le point de départ

Examiner ce que l'utilisateur a déjà :

| Situation | Action |
|---|---|
| **L'utilisateur a un fichier `.tex`** | → Chemin A : compiler avec pdflatex/xelatex (voir ci-dessous) |
| **L'utilisateur a un fichier `.docx`** | → Chemin B : convertir avec docx2pdf (voir ci-dessous) |
| **L'utilisateur n'a ni .tex ni .docx** | → Chemin C : orienter vers le skill de génération adapté (voir ci-dessous) |

---

## Chemin A — Compiler un .tex en PDF

Charger `references/compilation.md` section **LaTeX → PDF**.

Fournir les commandes dans cet ordre :
1. Commande de compilation standard (`pdflatex` ou `xelatex` selon le template)
2. Si le résultat contient des références bibliographiques : relancer une deuxième fois
3. En cas d'erreur : pointer vers `cv.log` et le troubleshooting MiKTeX

---

## Chemin B — Convertir un .docx en PDF

Charger `references/compilation.md` section **DOCX → PDF**.

Fournir les commandes dans cet ordre :
1. Commande docx2pdf (Python, requiert Microsoft Word installé)
2. Si Word n'est pas disponible : commande alternative LibreOffice
3. En cas d'erreur : pointer vers le troubleshooting docx2pdf

---

## Chemin C — Pas de fichier source disponible

Demander à l'utilisateur quelle qualité de rendu il préfère :

> "Pour générer le PDF, il faut d'abord créer le fichier source. Quelle qualité de rendu souhaitez-vous ?
> - **LaTeX** : typographie professionnelle, rendu publication, idéal pour les profils soignés
>   → skill `generation-cv-latex` → puis revenir ici pour compiler
> - **DOCX** : rapide, facilement modifiable sous Word/LibreOffice
>   → skill `generation-cv-docx` → puis revenir ici pour convertir"

Attendre la réponse avant de continuer.

---

## Règles universelles

- **Ne pas générer de contenu CV** — ce skill orchestre la conversion, pas la rédaction
- **Toujours vérifier** que le fichier source existe avant de donner les commandes
- **Confirmer le chemin complet** du fichier si l'utilisateur ne l'indique pas
