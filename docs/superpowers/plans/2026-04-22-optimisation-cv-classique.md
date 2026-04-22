# Optimisation CV Classique — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Parallelisation:** Tasks 1, 2, 3, 4 are fully independent — dispatch them in parallel. Task 5 requires all of 1–4 to be complete.

**Goal:** Ajouter une branche "CV classique" au pipeline existant via 3 nouveaux skills (`audit-cv`, `optimisation-cv`, `ciblage-cv`), invocables par des phrases naturelles comme "optimise ce CV".

**Architecture:** Approche additive pure — aucun skill existant modifié. `optimisation-cv` est le point d'entrée naturel (détecte le type d'input et orchestre normalisation si nécessaire). `audit-cv` est optionnel. `ciblage-cv` prend le YAML enrichi + une offre et produit une version ciblée.

**Tech Stack:** Markdown uniquement. Validation CI : `find skills/ -name "SKILL.md"` + `wc -l` sur chaque `references/*.md` (≤ 150 lignes).

---

## Task 1 : Créer le skill `audit-cv`

**Fichiers :**
- Créer : `skills/cv/audit-cv/SKILL.md`
- Créer : `skills/cv/audit-cv/references/grille-audit-cv.md`

- [ ] **Step 1.1 : Créer le répertoire**

```bash
mkdir -p skills/cv/audit-cv/references
```

- [ ] **Step 1.2 : Écrire `skills/cv/audit-cv/SKILL.md`**

Contenu exact :

```markdown
---
name: audit-cv
description: >
  Évalue un CV classique sur 6 dimensions (structure, qualité descriptions, cohérence
  narrative, pertinence compétences, accroche, lisibilité). Prend en entrée un profil
  YAML normalisé (issu de normalisation-profil) et optionnellement un rapport
  analyse-marche-emploi. Produit un rapport audit_cv avec priorites[], consommable par
  optimisation-cv. UTILISER avant optimisation-cv pour un diagnostic approfondi, ou
  invoquer directement optimisation-cv si un audit séparé n'est pas nécessaire.
---

# Audit CV — Point d'entrée

## Étape 1 — Vérifier les inputs

**Input obligatoire :**
- Profil YAML normalisé conforme au schéma `normalisation-profil/references/schema.md`.
  Si absent → invoquer `normalisation-profil` d'abord.

**Input optionnel :**

| Input | Effet si absent |
|---|---|
| Rapport marché (`analyse-marche-emploi`) | Dimension 4 marquée `non_evalue` |

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6`.

> L'audit exige du jugement interprétatif (détecter les descriptions vagues, évaluer
> la cohérence narrative, identifier les compétences implicites) — Haiku ne suffit pas,
> Opus n'est pas nécessaire pour un profil unique.

## Étape 3 — Charger la référence

Lire `references/grille-audit-cv.md` — définit les 6 dimensions, indicateurs, niveaux
(OK/Faible/Critique) et le format de sortie.

## Étape 4 — Auditer dimension par dimension

Appliquer la grille de `references/grille-audit-cv.md` dans l'ordre :

| # | Dimension | Source dans le profil |
|---|---|---|
| 1 | Structure | Sections présentes, équilibre longueur |
| 2 | Qualité des descriptions | `experiences[].realisations[]` |
| 3 | Cohérence narrative | `resume` + `experiences[].poste` + `competences[]` |
| 4 | Pertinence compétences | `competences[]` vs rapport marché si dispo |
| 5 | Accroche/résumé | `identite.resume` |
| 6 | Lisibilité | Densité bullets, longueur descriptions |

Pour chaque dimension :
1. Relever les indicateurs présents ou absents
2. Appliquer les règles → attribuer `OK`, `Faible` ou `Critique`
3. Documenter les gaps (max 2 lignes par indicateur défaillant)

## Étape 5 — Produire la sortie

**Bloc 1 — YAML d'audit** (` ```yaml … ``` `) conforme au format de `references/grille-audit-cv.md` :
- `audit_cv.dimensions` : 6 entrées avec `statut` + `indicateurs_defaillants`
- `audit_cv.priorites` : top 3 actions pour `optimisation-cv`

**Bloc 2 — Synthèse en prose** (3-5 phrases) :
- Points forts et zones critiques dominantes
- Risque principal
- Recommandation : invoquer `optimisation-cv` avec ce rapport

## Règles universelles

- Ne jamais inventer de données absentes du profil YAML
- Distinguer gap structurel (champ absent) et gap qualitatif (champ présent mais insuffisant)
- Dimension 4 `non_evalue` si rapport marché absent — l'indiquer explicitement
```

- [ ] **Step 1.3 : Écrire `skills/cv/audit-cv/references/grille-audit-cv.md`**

Contenu exact :

```markdown
# Grille d'audit — CV Classique

## Vue d'ensemble

| # | Dimension | Évaluable depuis YAML |
|---|---|---|
| 1 | Structure | Oui |
| 2 | Qualité des descriptions | Oui |
| 3 | Cohérence narrative | Oui |
| 4 | Pertinence compétences | Partiellement (rapport marché optionnel) |
| 5 | Accroche/résumé | Oui |
| 6 | Lisibilité | Oui |

---

## Dimension 1 — Structure

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| `identite` complet (nom, titre, email, tél.) | Tous présents | 1 champ `null` | Titre absent |
| `resume` présent | ≥ 2 phrases | 1 phrase | `null` |
| `experiences[]` | ≥ 2 avec dates + réalisations | Dates ou réalisations manquantes | `null` ou 0 exp. |
| `competences[]` | ≥ 5 entrées | 1–4 entrées | `null` |
| `formation[]` | ≥ 1 avec diplôme + date | Données partielles | `null` |

---

## Dimension 2 — Qualité des descriptions

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Format CAR | ≥ 70 % des réalisations | 40–69 % | < 40 % |
| Métriques | ≥ 1 par expérience > 1 an | Métriques sur < 50 % | Aucune métrique |
| Verbes vagues ("géré", "participé") | Aucun | 1–2 | ≥ 3 |
| Réalisations par expérience récente | ≥ 2 | 1 seule | `realisations: []` |

> Expériences "récentes" = les 3 dernières ou les 5 dernières années.

---

## Dimension 3 — Cohérence narrative

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Fil conducteur | Progression lisible | 1 poste hors trajectoire | Trajectoire incohérente |
| Alignement titre / expériences récentes | Titre reflète les postes récents | Titre générique | Titre contredit les postes |
| Compétences déclarées vs utilisées | Cohérentes | < 50 % couverture croisée | Compétences absentes de toutes les exp. |
| Gaps temporels | Aucun > 6 mois non expliqué | 1 gap non justifié | ≥ 2 gaps ou gap > 1 an |

---

## Dimension 4 — Pertinence compétences

> Si rapport marché absent → `statut: non_evalue`. Passer à dimension 5.

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Compétences clés marché présentes | ≥ 80 % | 50–79 % | < 50 % |
| Compétences en déclin | Aucune | 1 | ≥ 2 |
| Compétences implicites non déclarées | Aucune manque | 1–2 | ≥ 3 |

---

## Dimension 5 — Accroche/Résumé

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| `identite.resume` présent | ≥ 3 phrases | 1–2 phrases | `null` |
| Élément différenciant | Chiffre, spécialité ou secteur | Générique sans angle | Aucun élément |
| Orientation valeur (≠ liste compétences) | Orienté apport | Mixte | Autocentré ou copié-collé |

---

## Dimension 6 — Lisibilité

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Longueur bullets réalisations | 1–3 lignes | 4 lignes | > 4 lignes |
| Réalisations par expérience | ≤ 6 | 7–8 | > 8 |
| Description d'expérience hors réalisations | < 3 lignes | 3–5 lignes | > 5 lignes |
| `resume` | < 5 lignes | 5–7 lignes | > 7 lignes |

---

## Format de sortie

```yaml
audit_cv:
  dimensions:
    structure:
      statut: OK                    # OK | Faible | Critique
      indicateurs_defaillants: []
    qualite_descriptions:
      statut: Critique
      indicateurs_defaillants:
        - champ: metriques
          observation: "Aucune métrique sur 4 expériences"
    coherence_narrative:
      statut: OK
      indicateurs_defaillants: []
    pertinence_competences:
      statut: non_evalue
      indicateurs_defaillants: []
    accroche_resume:
      statut: Faible
      indicateurs_defaillants:
        - champ: identite.resume
          observation: "Résumé de 1 phrase — non différenciant"
    lisibilite:
      statut: OK
      indicateurs_defaillants: []
  priorites:
    - priorite: 1
      dimension: qualite_descriptions
      gap: "Absence de métriques"
      action: "Reformuler les 2 expériences principales en CAR avec métriques"
    - priorite: 2
      dimension: accroche_resume
      gap: "Résumé trop court, non différenciant"
      action: "Réécrire l'accroche en 3 phrases : valeur + spécialité + CTA implicite"
    - priorite: 3
      dimension: coherence_narrative
      gap: "Compétences déclarées non retrouvables dans les expériences"
      action: "Aligner la liste compétences avec les competences_utilisees des expériences"
```
```

- [ ] **Step 1.4 : Vérifier le nombre de lignes de la référence**

```bash
wc -l skills/cv/audit-cv/references/grille-audit-cv.md
```

Résultat attendu : ≤ 150. Si > 150, raccourcir les tableaux de dimensions.

- [ ] **Step 1.5 : Commit**

```bash
git add skills/cv/audit-cv/
git commit -m "feat(cv): add audit-cv skill — 6-dimension classic CV audit"
```

---

## Task 2 : Créer le skill `optimisation-cv`

**Fichiers :**
- Créer : `skills/cv/optimisation-cv/SKILL.md`
- Créer : `skills/cv/optimisation-cv/references/sections-cv.md`

- [ ] **Step 2.1 : Créer le répertoire**

```bash
mkdir -p skills/cv/optimisation-cv/references
```

- [ ] **Step 2.2 : Écrire `skills/cv/optimisation-cv/SKILL.md`**

Contenu exact :

```markdown
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
```

- [ ] **Step 2.3 : Écrire `skills/cv/optimisation-cv/references/sections-cv.md`**

Contenu exact :

```markdown
# Guide de rédaction — Sections CV Classique

## 1. Accroche / Résumé professionnel

### Structure recommandée (3-5 lignes)

```
Ligne 1 — Identité professionnelle : intitulé + années d'expérience + secteur(s)
Ligne 2 — Valeur principale : ce que tu apportes concrètement, avec un chiffre si possible
Ligne 3 — Spécialité ou angle différenciant : ce qui te distingue
Ligne 4 — (optionnel) Disponibilité ou type de poste recherché
```

### Exemples

| Avant | Après |
|---|---|
| "Ingénieur expérimenté cherchant de nouveaux défis" | "Ingénieur cloud AWS — 9 ans en architecture distribuée, spécialisé migrations zéro-downtime. A réduit les coûts infra de 30 % en moyenne sur 5 projets." |
| "Responsable RH passionnée" | "Responsable RH — 7 ans en PME industrielle. Experte GPEC et onboarding : time-to-productivity réduit de 40 % sur 3 ans." |

### Règles

- Écrire à la 3e personne implicite (sans "je") sauf convention sectorielle contraire
- Ne pas lister les compétences sans contexte ("Maîtrise de Excel, PowerPoint...")
- Inclure au moins 1 chiffre ou résultat concret
- Max 5 lignes — lisible en 10 secondes

---

## 2. Expériences — Format CAR avec métriques

### Structure CAR

```
Contexte  → Situation initiale ou enjeu (1 ligne max)
Action    → Ce que j'ai fait concrètement (verbe d'action fort)
Résultat  → Outcome mesurable (%, €, délai, volume)
```

### Verbes d'action forts

Piloté, Conçu, Déployé, Structuré, Négocié, Optimisé, Réduit, Lancé, Transformé, Formé

### Exemples CAR

| Avant (vague) | Après (CAR + métrique) |
|---|---|
| "Responsable du projet ERP" | "Piloté la migration SAP S/4HANA pour 8 filiales — livré 3 semaines avant planning, 0 incident P1 à l'ouverture" |
| "Amélioration des processus" | "Refondé le process d'onboarding (6 étapes → 3) — time-to-productivity réduit de 45 à 28 jours" |
| "Contribution aux ventes" | "Sur un portefeuille PME en décroissance (-12 % N-1), déployé une stratégie cross-sell — +340 k€ CA additionnel (+22 % vs objectif)" |

### Si aucune métrique disponible

Utiliser `[chiffre à compléter]` — ne jamais inventer. Proposer le type de métrique pertinent.

### Calibrage

- 2–4 réalisations par expérience récente (≤ 3 ans), 1–2 pour les expériences anciennes
- 1–3 lignes par bullet — couper si > 60 mots
- Commencer chaque bullet par un verbe (passé composé)

---

## 3. Compétences

### Organisation

```
Techniques  : langages, outils, logiciels, certifications techniques
Management  : taille d'équipe, budget, méthodes (Agile, PMP, Lean...)
Sectorielles: domaines métier, réglementations, secteurs
Langues     : niveau certifié (TOEIC, DELF) ou auto-évalué (B2, C1...)
```

### Règles

- Lister d'abord les compétences les plus différenciantes pour le poste visé
- Supprimer les génériques non différenciants ("Pack Office", "Gestion du temps")
- Utiliser les termes exacts du marché cible : "Python" pas "langage de script"
- Grouper les synonymes — garder le terme le plus recherché
- Certifications : format `Nom certif (émetteur, AAAA)`
- Cohérence obligatoire : chaque compétence listée doit être retrouvable dans les expériences
```

- [ ] **Step 2.4 : Vérifier le nombre de lignes de la référence**

```bash
wc -l skills/cv/optimisation-cv/references/sections-cv.md
```

Résultat attendu : ≤ 150. Si > 150, raccourcir les exemples.

- [ ] **Step 2.5 : Commit**

```bash
git add skills/cv/optimisation-cv/
git commit -m "feat(cv): add optimisation-cv skill — content improvement, CAR rewrite, natural language entry"
```

---

## Task 3 : Créer le skill `ciblage-cv`

**Fichiers :**
- Créer : `skills/cv/ciblage-cv/SKILL.md`
- Créer : `skills/cv/ciblage-cv/references/analyse-offre.md`

- [ ] **Step 3.1 : Créer le répertoire**

```bash
mkdir -p skills/cv/ciblage-cv/references
```

- [ ] **Step 3.2 : Écrire `skills/cv/ciblage-cv/SKILL.md`**

Contenu exact :

```markdown
---
name: ciblage-cv
description: >
  Adapte un CV pour une offre d'emploi spécifique. Accepte un YAML normalisé ou enrichi
  (issu de optimisation-cv) et un texte d'offre d'emploi. Invocable par "cible mon CV
  pour cette offre", "adapte mon CV pour [poste]", "optimise mon CV pour cette annonce".
  Si un CV brut est fourni à la place d'un YAML, orchestre normalisation + optimisation d'abord.
  Produit un bloc YAML ciblé distinct du YAML source et un résumé structuré des adaptations.
---

# Ciblage CV — Point d'entrée

## Étape 1 — Vérifier les inputs

**Inputs obligatoires :**
- CV source : YAML normalisé/enrichi, ou CV brut (texte/DOCX/PDF)
- Offre d'emploi : texte complet (coller l'annonce dans la conversation)

**Si CV brut fourni :**
Invoquer `normalisation-profil` (+ `extraction-docx` ou `extraction-pdf` si fichier),
puis `optimisation-cv`, puis reprendre ici avec le YAML enrichi produit.

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6`.

> Le ciblage exige d'analyser l'offre, de scorer chaque expérience et de reformuler
> le résumé — tâche de raisonnement multi-sources qui exclut Haiku.

## Étape 3 — Charger la référence

Lire `references/analyse-offre.md` — extraction mots-clés, scoring pertinence,
règles de réordonnancement, reformulation du résumé pour le poste cible.

## Étape 4 — Analyser l'offre

Appliquer §1 de `references/analyse-offre.md` :
1. Extraire `must_have[]`, `nice_to_have[]`, `keywords[]`, `secteur`, `ton`
2. Identifier le niveau de séniorité attendu
3. Normaliser les termes techniques selon le vocabulaire exact de l'offre

## Étape 5 — Scorer et réordonner

Appliquer §2 et §3 de `references/analyse-offre.md` :
1. Attribuer un score (0–3) à chaque expérience et réalisation
2. Réordonner `experiences[]` et `realisations[]` par pertinence décroissante
3. Réordonner `competences[]` pour mettre les `must_have` en premier
4. Ajouter dans `competences[]` les termes de l'offre présents dans les expériences
   mais absents de la liste

## Étape 6 — Reformuler le résumé

Appliquer §4 de `references/analyse-offre.md` :
- Ligne 1 : intitulé aligné sur l'offre + années d'expérience pertinente
- Ligne 2 : valeur principale vs `must_have` de l'offre (avec métrique si possible)
- Ligne 3 : angle différenciant non spécifié dans l'offre

## Étape 7 — Produire la sortie

**Bloc 1 — YAML ciblé** (` ```yaml … ``` `) :
- Même schéma que le YAML source
- `experiences[]` et `realisations[]` réordonnées
- `identite.resume` reformulé pour le poste
- `competences[]` réordonnées et enrichies
- `meta.cible: { poste, entreprise, date }` ajouté au bloc `meta` existant

**Bloc 2 — Résumé des adaptations** conforme au format `adaptations:` de
`references/analyse-offre.md` §5

## Règles universelles

- Ne jamais supprimer d'expériences — réordonner uniquement
- Ne jamais inventer de compétences absentes du profil source
- Signaler si le profil couvre < 60 % des `must_have` — le candidat doit en être informé
- Proposer la suite : "Pour générer le DOCX ciblé → `generation-cv-docx`"
```

- [ ] **Step 3.3 : Écrire `skills/cv/ciblage-cv/references/analyse-offre.md`**

Contenu exact :

```markdown
# Analyse d'offre — Extraction, Scoring, Réordonnancement

## 1. Extraction depuis l'offre d'emploi

| Catégorie | Source dans l'offre | Champ résultant |
|---|---|---|
| Intitulé exact du poste | Titre de l'offre | `cible.poste` |
| Compétences indispensables | "Requis", "Obligatoire", "Vous maîtrisez" | `cible.must_have[]` |
| Compétences souhaitées | "Apprécié", "Un plus", "Idéalement" | `cible.nice_to_have[]` |
| Secteur / contexte | Description entreprise | `cible.secteur` |
| Ton attendu | Tutoiement, jargon, culture décrite | `cible.ton` |
| Mots-clés récurrents | Termes répétés ≥ 2× dans l'offre | `cible.keywords[]` |

### Méthode

1. Lire l'offre en entier avant d'extraire
2. Distinguer hard skills (techniques, certifications) et soft skills (leadership, autonomie)
3. Normaliser les termes : reprendre les mots exacts de l'offre
4. Identifier le niveau séniorité implicite ("senior", "autonome", "pilote", "manage")

---

## 2. Scoring de pertinence profil / offre

Pour chaque expérience et réalisation du profil :

| Score | Critère |
|---|---|
| 3 — Fort | Couvre ≥ 1 `must_have` explicitement |
| 2 — Moyen | Couvre ≥ 1 `nice_to_have` ou `keyword` |
| 1 — Faible | Tangentiellement lié |
| 0 — Hors sujet | Aucun lien avec l'offre |

**Règle :** Ne jamais supprimer une expérience — réordonner, pas effacer.

---

## 3. Règles de réordonnancement

### Expériences (`experiences[]`)

- Conserver l'ordre chronologique inversé comme base
- Remonter une expérience ancienne si son score est 3 et les autres ≤ 1
- Exception : ne jamais remonter une expérience de > 10 ans en première position

### Réalisations (`realisations[]`)

- Réordonner par score décroissant au sein de chaque expérience
- Réalisations score 0 : conserver mais déplacer en dernier
- Limiter à 4 réalisations max par expérience dans la version ciblée

### Compétences (`competences[]`)

- Placer en premier les compétences correspondant aux `must_have`
- Ajouter les `keywords` présents dans les expériences mais absents de la liste
- Ne pas supprimer de compétences — réordonner uniquement

---

## 4. Reformulation du résumé pour le poste cible

### Structure

```
Ligne 1 — Intitulé exactement aligné sur l'offre + années d'expérience pertinente
Ligne 2 — Valeur principale vs must_have de l'offre (avec métrique si possible)
Ligne 3 — Angle différenciant : ce que le candidat apporte que l'offre ne spécifie pas
```

### Règles

- Reprendre 2–3 termes exacts de l'offre dans la première phrase (signal ATS)
- Ne pas copier-coller des phrases de l'offre
- Rester fidèle aux données du profil — ne pas inventer de compétences
- Si l'offre tutoie et que c'est la norme du secteur, adapter le ton

---

## 5. Résumé des adaptations (output obligatoire)

```yaml
adaptations:
  resume_modifie: true
  experiences_reordonnees:
    - poste: "Nom du poste"
      raison: "Score 3 — couvre must_have 'Python' et 'architecture cloud'"
  realisations_deprioritisees:
    - texte_court: "Gestion administrative des fournisseurs"
      raison: "Score 0 — hors sujet pour le poste cible"
  competences_ajoutees:
    - competence: "FastAPI"
      raison: "Présent dans experiences[1].competences_utilisees, absent de competences[]"
  alerte_couverture: null   # "Profil couvre seulement 55% des must_have" si < 60%
  meta_cible:
    poste: "Lead Engineer Data"
    entreprise: "Acme Corp"
    date: "2026-04-22"
```
```

- [ ] **Step 3.4 : Vérifier le nombre de lignes de la référence**

```bash
wc -l skills/cv/ciblage-cv/references/analyse-offre.md
```

Résultat attendu : ≤ 150. Si > 150, raccourcir §1 ou les exemples §5.

- [ ] **Step 3.5 : Commit**

```bash
git add skills/cv/ciblage-cv/
git commit -m "feat(cv): add ciblage-cv skill — job offer targeting, keyword scoring, YAML reorder"
```

---

## Task 4 : Mettre à jour `CLAUDE.md`

**Fichiers :**
- Modifier : `CLAUDE.md`

- [ ] **Step 4.1 : Ajouter les 3 nouveaux skills dans le tableau `### Current Skills`**

Dans la section `| cv | ... |` du tableau Current Skills de `CLAUDE.md`, ajouter ces 3 lignes après la ligne `generation-cv-pdf` :

```markdown
| `cv` | `audit-cv` | Évalue CV classique sur 6 dimensions, produit rapport `audit_cv` avec priorités |
| `cv` | `optimisation-cv` | Améliore contenu CV (CAR, accroche, compétences) ; point d'entrée naturel pipeline classique |
| `cv` | `ciblage-cv` | Adapte un CV optimisé pour une offre d'emploi ; produit YAML ciblé distinct |
```

- [ ] **Step 4.2 : Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md — add audit-cv, optimisation-cv, ciblage-cv to skills table"
```

---

## Task 5 : Validation finale + sync

**Dépend de :** Tasks 1, 2, 3, 4 complètes

- [ ] **Step 5.1 : Vérifier la structure de tous les nouveaux skills**

```bash
find skills/cv/audit-cv skills/cv/optimisation-cv skills/cv/ciblage-cv -name "SKILL.md"
```

Résultat attendu — 3 fichiers :
```
skills/cv/audit-cv/SKILL.md
skills/cv/optimisation-cv/SKILL.md
skills/cv/ciblage-cv/SKILL.md
```

- [ ] **Step 5.2 : Vérifier toutes les références ≤ 150 lignes**

```bash
find skills/cv/audit-cv skills/cv/optimisation-cv skills/cv/ciblage-cv -path "*/references/*.md" -exec wc -l {} \;
```

Résultat attendu : chaque fichier ≤ 150. Si un fichier dépasse, raccourcir ses tableaux.

- [ ] **Step 5.3 : Synchroniser vers Claude Code**

```bash
./scripts/sync-to-claude.sh
```

Résultat attendu : `OK audit-cv`, `OK optimisation-cv`, `OK ciblage-cv` dans la sortie.

- [ ] **Step 5.4 : Mettre à jour TODO.md et DONE.md**

Dans `TODO.md`, aucune tâche existante ne couvre ces skills — rien à cocher.

Dans `DONE.md`, ajouter une section sous la date du jour (format existant : `## YYYY-MM-DD` > `### [TAG] titre`) :

```markdown
## 2026-04-22

### [CV] Pipeline CV classique — 3 nouveaux skills (PR #TBD)

- [x] Créer skill `audit-cv` — audit CV classique 6 dimensions, rapport `audit_cv` avec priorites[]
- [x] Créer skill `optimisation-cv` — point d'entrée naturel, réécriture CAR, accroche, YAML enrichi
- [x] Créer skill `ciblage-cv` — ciblage offre emploi, scoring pertinence, réordonnancement YAML ciblé
- [x] Mettre à jour `CLAUDE.md` — tableau Current Skills
```

- [ ] **Step 5.5 : Commit final**

```bash
git add TODO.md DONE.md
git commit -m "chore: update TODO/DONE — feat/cv-generation-skills branch closing (audit-cv, optimisation-cv, ciblage-cv)"
```
