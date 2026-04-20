---
name: extraction-pdf
description: >
  Agent spécialisé pour l'extraction de données structurées depuis tout type de PDF :
  CV, contrats, factures, rapports, fiches techniques.
  Produit un objet YAML/JSON structuré selon le type de document détecté.
  Pour les CV et profils, l'output est compatible avec le schéma normalisation-profil.
  UTILISER pour toute demande d'extraction depuis un fichier PDF, quelle que soit
  la nature du document.
---

# Extraction PDF — Point d'entrée

## Modèle

**Modèle unique : `claude-haiku-4-5`**

L'extraction PDF est une tâche mécanique de lecture et de restitution structurée — aucun jugement ni raisonnement complexe n'est requis. Haiku suffit et minimise le coût.

---

## Étape 1 — Identifier le type de document

| Type de document | Indicateurs | Référence à charger |
|---|---|---|
| **CV / Profil professionnel** | Expériences, formations, compétences, informations de contact | `references/extraction-cv.md` |
| **Autre document** | Contrat, facture, rapport, fiche technique, note, présentation | `references/extraction-generique.md` |

> En cas de doute : demander à l'utilisateur de préciser le type de document avant d'extraire.

---

## Étape 2 — Charger la référence adaptée

- **CV / Profil** → lire `references/extraction-cv.md` puis extraire selon le schéma normalisation-profil
- **Autre document** → lire `references/extraction-generique.md` puis extraire selon le type détecté

---

## Étape 3 — Règles universelles

- **Lire le PDF en entier** avant d'extraire — ne pas s'arrêter à la première page
- **Ne jamais inventer** d'information absente du document — utiliser `null` pour les champs manquants
- **Signaler les ambiguïtés** : marquer `[?]` toute valeur incertaine avec la formulation source
- **Signaler les zones illisibles** si le PDF est scanné ou de mauvaise qualité
- **Restituer la langue du document** sauf instruction contraire
