---
name: analyse-documents
description: >
  Agent spécialisé pour l'analyse, l'extraction et la synthèse de documents :
  PDF, rapports, specs, fichiers de données, contrats, notes.
  Couvre : extraction de données structurées, résumé, comparaison de documents,
  identification de points clés, Q&A sur document, analyse de cohérence.
  UTILISER pour toute demande impliquant un fichier à lire, comprendre, extraire
  ou synthétiser — même si la demande semble simple.
---

# Analyse de Documents — Point d'entrée

## Étape 1 — Choisir le modèle

| Type de tâche | Critères | Modèle |
|---|---|---|
| **Extraction** | Récupérer des données structurées, listes, tableaux, champs précis | `claude-haiku-4-5` |
| **Classification** | Catégoriser, trier, labelliser des documents ou sections | `claude-haiku-4-5` |
| **Résumé simple** | Résumer un document court et factuel | `claude-haiku-4-5` |
| **Analyse** | Comprendre l'intent, identifier des tensions, des risques, des incohérences | `claude-sonnet-4-6` |
| **Synthèse multi-docs** | Croiser plusieurs documents, identifier divergences, produire une vue unifiée | `claude-sonnet-4-6` |
| **Q&A complexe** | Répondre à des questions qui nécessitent du raisonnement sur le contenu | `claude-sonnet-4-6` |

> Règle de décision rapide : si la tâche est **"trouver et restituer"** → Haiku. Si c'est **"comprendre et interpréter"** → Sonnet.

---

## Étape 2 — Charger la référence adaptée

| Contexte | Fichier à lire |
|---|---|
| Extraction de données / champs / tableaux | `references/extraction.md` |
| Résumé, analyse, synthèse, Q&A | `references/analyse-synthese.md` |
| Comparaison ou croisement de plusieurs documents | `references/multi-docs.md` |

---

## Étape 3 — Règles universelles

- **Toujours lire le document en entier** avant de répondre
- **Ne jamais inventer** d'information absente du document — signaler explicitement les lacunes
- **Citer les sources** : indiquer la section ou page d'où provient une information clé
- **Distinguer** ce qui est dans le document de ce qui est une inférence ou une interprétation
