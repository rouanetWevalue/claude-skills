---
name: extraction-docx
description: >
  Agent spécialisé pour l'extraction de données structurées depuis des fichiers DOCX, PPTX, DOC et PPT.
  Produit un objet YAML/JSON structuré selon le type de document détecté.
  Pour les CV et profils, l'output est compatible avec le schéma normalisation-profil.
  UTILISER pour toute demande d'extraction depuis un fichier Word ou PowerPoint,
  quelle que soit la nature du document.
---

# Extraction DOCX/PPT — Point d'entrée

## Modèle

**Modèle unique : `claude-haiku-4-5`**

L'extraction DOCX/PPT est une tâche mécanique de lecture et de restitution structurée — aucun jugement ni raisonnement complexe n'est requis. Haiku suffit et minimise le coût.

---

## Étape 1 — Identifier le type de document

| Type de document | Indicateurs | Référence à charger |
|---|---|---|
| **CV / Profil professionnel** | Expériences, formations, compétences, informations de contact | `references/extraction-cv.md` |
| **Autre document** | Contrat, rapport, présentation, note, fiche technique | `references/extraction-generique.md` |

> En cas de doute : demander à l'utilisateur de préciser le type de document avant d'extraire.

---

## Étape 2 — Charger la référence adaptée

- **CV / Profil** → lire `references/extraction-cv.md` puis extraire selon le schéma normalisation-profil
- **Autre document** → lire `references/extraction-generique.md` puis extraire selon le type détecté

---

## Étape 3 — Règles universelles

- **Lire le document en entier** avant d'extraire — DOCX et PPTX peuvent être multi-section
- **Ne jamais inventer** d'information absente du document — utiliser `null` pour les champs manquants
- **Signaler les ambiguïtés** : marquer `[?]` toute valeur incertaine avec la formulation source
- **Préserver la structure** : styles Word (Titre 1, Titre 2) et layouts PowerPoint sont des indices de structure
- **Restituer la langue du document** sauf instruction contraire
