---
name: optimisation-cv
description: >
  Améliore la qualité du contenu d'un CV classique (Word, PDF, texte). Accepte un CV brut,
  un fichier DOCX/PDF, ou un profil YAML normalisé. Invocable par "optimise ce CV",
  "optimise le CV suivant", "améliore mon CV", "optimise ce document".
  Reformule les descriptions en format CAR, réécrit l'accroche, aligne les compétences.
  Produit un profil YAML enrichi (drop-in pour generation-cv-*) et un aperçu des modifications.
  Peut consommer un rapport audit-cv pour prioriser, ou détecter lui-même les faiblesses.
---

# Optimisation CV — Point d'entrée

## Étape 1 — Détecter et préparer l'input

| Input détecté | Action |
|---|---|
| Profil YAML normalisé | Passer directement à l'étape 2 |
| Texte brut / CV collé dans la conversation | Invoquer `normalisation-profil` → utiliser le YAML produit |
| Chemin `.docx` ou fichier DOCX joint | Invoquer `extraction-docx` → `normalisation-profil` → utiliser le YAML |
| Chemin `.pdf` ou fichier PDF joint | Invoquer `extraction-pdf` → `normalisation-profil` → utiliser le YAML |

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6`.

> La réécriture de sections CV exige du jugement rédactionnel (ton, formulation impactante,
> cohérence narrative) — Haiku ne suffit pas. Opus n'est pas justifié pour un profil unique.

## Étape 3 — Charger la référence

Lire `references/sections-cv.md` — guide de rédaction par section : accroche, format CAR,
compétences ATS-friendly.

## Étape 4 — Identifier les sections à optimiser

**Si un rapport `audit-cv` est fourni :**
Lire `audit_cv.priorites[]` et traiter les sections dans l'ordre déclaré.

**Si aucun rapport d'audit :**
Scanner le profil et dresser la liste des faiblesses dans cet ordre de priorité :

| Signal | Section concernée |
|---|---|
| `identite.resume` absent ou < 2 phrases | Accroche |
| `realisations[].metrique: null` sur ≥ 50 % des expériences récentes | Expériences |
| Verbes vagues ("géré", "participé", "responsable de") | Expériences |
| `competences[]` < 5 entrées ou incohérentes avec les expériences | Compétences |

Traiter les 3 faiblesses les plus impactantes — ne pas aller au-delà sauf demande explicite.

## Étape 5 — Réécrire les sections

Pour chaque section identifiée, appliquer les règles de `references/sections-cv.md` :

- **Accroche** (`identite.resume`) : structure 3-5 lignes, élément différenciant, ≥ 1 chiffre
- **Expériences** (`experiences[].realisations[]`) : format CAR, verbe fort, métrique ou placeholder
- **Compétences** (`competences[]`) : grouper par catégorie, supprimer les génériques,
  termes exacts du marché

Règle absolue : ne jamais inventer de données absentes du profil. Utiliser
`[chiffre à compléter]` si aucune métrique n'est disponible.

## Étape 6 — Produire la sortie

**Bloc 1 — YAML enrichi** (` ```yaml … ``` `) :
- Même schéma que l'entrée (`normalisation-profil/references/schema.md`)
- Seuls les champs modifiés sont réécrits : `identite.resume`, `realisations[].texte`,
  `realisations[].metrique`, `competences[]`

**Bloc 2 — Aperçu des modifications** (tableau avant/après) :
- Une ligne par champ modifié : champ | avant | après
- Permet de relire et valider avant de générer le document final

## Règles universelles

- Ne jamais inventer de métriques absentes du profil source
- Toujours proposer le prochain skill : "Pour générer le DOCX → `generation-cv-docx`.
  Pour cibler une offre → `ciblage-cv`."
