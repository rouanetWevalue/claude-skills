# Infos complémentaires — par template CV DOCX

Ce fichier est chargé à l'Étape 2 du routing pour identifier les champs
à collecter selon le ou les templates sélectionnés.

**Règle universelle** : tout champ non fourni par l'utilisateur → valeur `None`
dans le dictionnaire Python. Le template doit omettre le bloc correspondant
(`if valeur:`) — ne jamais afficher un label sans valeur.

---

## classique

Champs à vérifier dans le profil YAML (demander si absent(s)) :
- `linkedin_url` : URL profil LinkedIn (ex : https://linkedin.com/in/prenom-nom)
- `site_web` : portfolio ou site personnel (optionnel)

Photo : **non supportée** par ce template.

---

## moderne

Champs à vérifier dans le profil YAML (demander si absent(s)) :
- `linkedin_url` : URL profil LinkedIn
- `site_web` : portfolio ou site personnel (optionnel)
- `github_url` : profil GitHub (optionnel)

Photo : **optionnelle**.
→ Si absente du profil YAML : demander "Souhaitez-vous inclure une photo ?
  Si oui, fournissez le chemin absolu du fichier image (.jpg ou .png)."
→ Si l'utilisateur ne souhaite pas de photo : `chemin_photo = None`
→ La photo est insérée en haut de la sidebar avec `width=Cm(3.5)`
  (nécessite `pip install Pillow` en plus de python-docx)

---

## minimaliste

Vérifier la présence dans `identite` (champs essentiels pour la lisibilité ATS — demander si absents) :
- `email` : adresse email de contact
- `telephone` : numéro de téléphone
- `localisation` : ville et/ou pays

Photo : **non supportée** (incompatible avec les parseurs ATS — les images
sont ignorées ou génèrent des erreurs de parsing).

---

## wevalue

Champs à vérifier : à définir lors de l'implémentation (charte WeValue en attente).
Photo : à définir.

→ Template en attente de la charte graphique WeValue.
  Voir `template-wevalue.md` pour les instructions.
