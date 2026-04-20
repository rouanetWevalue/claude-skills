---
name: generation-cv-ppt
description: >
  Génère une présentation profil "1 pager" au format PPT depuis un profil
  YAML normalisé. Format : 1 slide titre + 1–2 slides compétences/expériences.
  Idéal pour les entretiens ou les profils commerciaux. Produit le code
  Python complet via python-pptx. Requiert Python 3.x + python-pptx.
---

# Génération de CV PPT — Point d'entrée

## Modèle

**`claude-haiku-4-5`** — la tâche est mécanique : mapper les champs du
profil YAML vers des zones de texte, tableaux et shapes PowerPoint.
Pas de raisonnement éditorial requis.

---

## Étape 1 — Charger la référence

Charger `references/python-pptx-patterns.md` — ce fichier contient :
- Les imports et l'initialisation de la présentation
- Les helpers pour zones de texte, tableaux et shapes
- Le plan de 3 slides et les patterns pour chacune
- Un exemple complet de slide profil

---

## Étape 2 — Règles de génération

- **Entrée attendue** : profil YAML conforme au schéma `normalisation-profil/references/schema.md`
- **Sortie** : script Python complet entre triple backticks ` ```python `
- Le script se nomme `generer_cv_ppt.py` et sauvegarde `cv_profil.pptx`
- Les données du profil sont embarquées dans le script en dictionnaire Python
- Format de présentation : 16:9 (Widescreen), 3 slides maximum
- **Slide 1** : titre, nom, titre professionnel, coordonnées, résumé
- **Slide 2** : compétences (tableau par catégorie) + langues + certifications
- **Slide 3** (si expériences ≥ 2 ou projets présents) : 2–3 expériences clés + projets
- **Champ `null`** → zone de texte ou ligne de tableau omise

---

## Étape 3 — Instruction d'exécution

Après le bloc de code, toujours indiquer :

```
# Exécution
pip install python-pptx
python generer_cv_ppt.py
# Résultat : cv_profil.pptx dans le répertoire courant
```
