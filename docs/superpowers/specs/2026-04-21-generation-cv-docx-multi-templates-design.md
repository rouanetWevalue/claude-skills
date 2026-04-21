# Design — generation-cv-docx multi-templates

**Date** : 2026-04-21
**Skill cible** : `skills/cv/generation-cv-docx/`
**Statut** : validé

---

## Contexte

Le skill `generation-cv-docx` existant génère un CV Word depuis un profil YAML normalisé, mais ne propose qu'un seul template hardcodé (en-tête centré, titres bleus). L'objectif est d'ajouter la sélection de templates multiples, la collecte d'informations complémentaires selon le template choisi, et une architecture extensible pour ajouter de nouveaux templates à l'avenir.

---

## Périmètre V1

- **4 templates** : Classique Corporate, Moderne Bicolonne, Minimaliste ATS-Safe, WeValue (stub)
- **Photo** : optionnelle, uniquement sur Moderne Bicolonne
- **Infos complémentaires** : collectées pendant la génération, selon le template (champs manquants du profil YAML)
- **PDF** : inchangé — `generation-cv-pdf` orchestre la conversion `.docx → PDF` via `docx2pdf`
- **WeValue** : placeholder prêt à recevoir la charte graphique (couleurs, police, logo) lors d'une prochaine itération

---

## Architecture des fichiers

```
skills/cv/generation-cv-docx/
├── SKILL.md                        ← modifié
└── references/
    ├── shared-patterns.md          ← renommé depuis python-docx-patterns.md
    ├── infos-complementaires.md    ← nouveau
    ├── template-classique.md       ← nouveau
    ├── template-moderne.md         ← nouveau
    ├── template-minimaliste.md     ← nouveau
    └── template-wevalue.md         ← nouveau (stub)
```

**Règle d'extensibilité** : ajouter un template = créer `references/template-<nom>.md` + ajouter une entrée dans `SKILL.md` (menu) et dans `infos-complementaires.md` (champs requis). Aucun autre fichier à modifier.

**Contrainte CI** : chaque fichier de référence ≤ 150 lignes. Les layouts complexes sont découpés si nécessaire.

---

## Routing SKILL.md

### Modèle
- `claude-haiku-4-5` par défaut (tâche mécanique : mapping YAML → python-docx)
- `claude-sonnet-4-6` si le profil est incomplet et nécessite un jugement éditorial sur les champs manquants

### Étape 1 — Sélection du template

Si le template n'est pas précisé dans la demande, afficher le menu :

```
Quel template souhaitez-vous ?
- classique  : sobre, une colonne, serif, idéal corporate / conseil / finance
- moderne    : bicolonne avec sidebar colorée, idéal tech / startup / créatif
- minimaliste: noir & blanc, une colonne, 100 % lisible par les ATS
- wevalue    : [en cours de développement — charte WeValue à venir]
```

**Si WeValue est sélectionné** : informer l'utilisateur que ce template est en attente de la charte graphique, et lui demander de choisir un autre template en attendant.

**Compagnon visuel** : si disponible dans la session, proposer de l'activer pour afficher les aperçus des templates avant que l'utilisateur ne choisisse.

Charger après le choix :
- `references/shared-patterns.md`
- `references/template-<choix>.md`
- `references/infos-complementaires.md`

### Étape 2 — Collecte des infos complémentaires

1. Dans `infos-complementaires.md`, lire la section correspondant au template choisi
2. Comparer les champs requis avec ce qui est présent dans le profil YAML
3. Poser les questions pour les champs manquants (en bloc si ≤ 3, une par une si > 3)
4. Si photo optionnelle (template `moderne`) : demander si l'utilisateur souhaite en inclure une, et si oui, le chemin absolu du fichier image (`.jpg`, `.png`)

### Étape 3 — Génération du script Python

- Sortie : script `generer_cv.py` complet entre triple backticks ` ```python `
- Profil embarqué en dictionnaire Python (pas de lecture YAML externe)
- Infos complémentaires collectées intégrées dans le dictionnaire
- Blocs `if valeur:` pour chaque champ optionnel
- Si photo : utiliser `python-docx` + `Pillow` (table 2 colonnes dans l'en-tête)
- Nom du fichier de sortie : `cv-<template>.docx`

### Étape 4 — Instructions d'exécution

```
pip install python-docx          # toujours
pip install Pillow               # uniquement si photo
python generer_cv.py
# Résultat : cv-<template>.docx dans le répertoire courant
# Pour convertir en PDF → skill generation-cv-pdf
```

---

## Structure des fichiers de référence templates

Chaque `template-<nom>.md` suit ce gabarit :

```markdown
# Template <Nom> — CV DOCX

## Caractéristiques visuelles
[mise en page, couleurs hex, police, photo oui/non + position]

## Infos complémentaires requises
[renvoi vers infos-complementaires.md]

## Preamble python-docx
[styles de page, marges, couleurs, polices]

## En-tête
[code python-docx : nom, titre, coordonnées]

## En-tête avec photo (si applicable)
[code avec Table 2 colonnes : photo gauche, infos droite]

## Sections du corps
[Expériences, Formation, Compétences, Langues, Certifications…]

## Sauvegarde
doc.save("cv-<template>.docx")
```

---

## Fichier infos-complementaires.md

```markdown
## classique
Champs à vérifier : linkedin_url, site_web
Photo : non

## moderne
Champs à vérifier : linkedin_url, site_web, github_url
Photo : oui (optionnelle — demander le chemin si absent du profil)

## minimaliste
Champs à vérifier : email, telephone, localisation (contact de base seulement)
Photo : non (incompatible ATS)

## wevalue
→ Stub — voir instructions dans template-wevalue.md
```

---

## Templates V1 — caractéristiques

| Template | Colonnes | Police | Couleur principale | Photo | Cible |
|---|---|---|---|---|---|
| classique | 1 | Georgia (serif) | Bleu ardoise `#2c3e50` | Non | Corporate, finance, conseil |
| moderne | 2 (sidebar 38%) | Arial/Helvetica | Vert `#2d6a4f` | Optionnelle | Tech, startup, créatif |
| minimaliste | 1 | Arial | Noir `#111111` | Non | Universel, compatible ATS |
| wevalue | TBD | TBD | TBD | TBD | Consulting WeValue |

---

## Ce qui ne change pas

- Le schéma d'entrée YAML (`normalisation-profil/references/schema.md`) — inchangé
- Le skill `generation-cv-pdf` — inchangé (continue d'orchestrer `.docx → PDF`)
- Les autres skills CV — inchangés

---

## Hors périmètre V1

- Template WeValue (stub uniquement — implémentation lors de la réception de la charte)
- Compagnon visuel lors de la génération (proposition optionnelle au choix du template)
- Génération multi-templates en un seul run
- Thème sombre
