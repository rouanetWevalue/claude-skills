---
name: generation-cv-docx
description: >
  Génère un CV au format DOCX depuis un profil YAML normalisé.
  Produit le code Python complet utilisant python-docx que l'utilisateur
  exécute localement. Met en forme : en-tête, sections, bullets, styles.
  Requiert Python 3.x + python-docx (`pip install python-docx`).
---

# Génération de CV DOCX — Point d'entrée

## Modèle

**`claude-haiku-4-5`** — la tâche est mécanique : traduire les champs du
profil YAML en appels d'API python-docx selon des patterns fixes.
Aucun raisonnement éditorial n'est requis.

---

## Étape 1 — Charger la référence

Charger `references/python-docx-patterns.md` — ce fichier contient :
- Les imports et l'initialisation du document
- Les helpers de styles (titres, corps, bullets)
- Le pattern de l'en-tête et de chaque section du profil
- Un exemple complet de section Expériences

---

## Étape 2 — Règles de génération

- **Entrée attendue** : profil YAML conforme au schéma `normalisation-profil/references/schema.md`
- **Sortie** : script Python complet entre triple backticks ` ```python `
- Le script se nomme `generer_cv.py` et sauvegarde `cv.docx`
- Les données du profil sont embarquées directement dans le script sous forme de dictionnaire Python (pas de lecture de fichier YAML externe)
- **Champ `null`** dans le profil → bloc conditionnel `if valeur:` avant d'écrire la section
- Sections du profil à couvrir dans l'ordre : identité, résumé, expériences, formations, compétences, langues, certifications, projets, publications, distinctions, centres d'intérêt

---

## Étape 3 — Instruction d'exécution

Après le bloc de code, toujours indiquer :

```
# Exécution
pip install python-docx
python generer_cv.py
# Résultat : cv.docx dans le répertoire courant
```
