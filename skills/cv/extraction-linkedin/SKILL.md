---
name: extraction-linkedin
description: >
  Agent spécialisé pour l'extraction d'un profil LinkedIn sous forme structurée,
  conforme au schéma normalisation-profil.
  Deux modes : copier/coller du profil par l'utilisateur (défaut absolu)
  ou navigation via MCP Playwright sur demande explicite uniquement.
  UTILISER pour toute demande d'extraction ou de structuration d'un profil LinkedIn.
---

# Extraction LinkedIn — Point d'entrée

## Modèle

**Modèle unique : `claude-haiku-4-5`**

L'extraction LinkedIn est une tâche de mapping structuré — les sections sont standardisées, aucun jugement complexe n'est requis. Haiku suffit et minimise le coût.

---

## Étape 1 — Choisir le mode d'extraction

**Règle absolue : toujours demander le copier/coller en premier, sans exception.**

Ne jamais proposer l'URL comme option par défaut, même si l'utilisateur a mentionné un lien.

| Mode | Déclencheur | Action |
|---|---|---|
| **Copier/coller** (défaut) | Toujours, sauf demande explicite d'URL | Demander à l'utilisateur de coller le texte du profil LinkedIn |
| **URL + Playwright** | Seulement si l'utilisateur demande explicitement la navigation | Vérifier la disponibilité du MCP Playwright, puis naviguer |

### Message à envoyer à l'utilisateur (mode copier/coller)

> "Pour extraire ce profil LinkedIn, merci de copier l'intégralité de la page LinkedIn (Ctrl+A, Ctrl+C depuis le profil) et de la coller ici."

### Mode URL (sur demande explicite uniquement)

1. Vérifier que le MCP Playwright est disponible dans la session courante
2. Si disponible : naviguer vers l'URL, faire défiler la page pour charger toutes les sections, extraire le texte
3. Si non disponible : informer l'utilisateur et lui demander le copier/coller
4. **Rappel obligatoire** : LinkedIn peut bloquer la navigation automatisée — l'extraction par URL peut échouer

---

## Étape 2 — Charger la référence

Quelle que soit la source (copier/coller ou URL), charger `references/champs-linkedin.md` pour le mapping des sections LinkedIn vers le schéma normalisation-profil.

---

## Étape 3 — Règles universelles

- **Ne jamais inventer** d'information absente du profil — `null` pour tout champ manquant
- **Signaler les ambiguïtés** : `[?]` avec la formulation source si une valeur est incertaine
- **Restituer la langue du profil** (`meta.langue_profil`) même si les instructions sont en français
- **Champs `meta`** : `source: "linkedin"`, `date_extraction:` date du jour (YYYY-MM-DD)
- Produire un YAML complet conforme au schéma normalisation-profil
