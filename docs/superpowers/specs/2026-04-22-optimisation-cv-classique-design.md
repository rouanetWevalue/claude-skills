# Design — Optimisation CV Classique

**Date** : 2026-04-22
**Branche** : feat/cv-generation-skills
**Statut** : Approuvé

---

## Contexte

Le pipeline CV existant couvre LinkedIn de bout en bout (`audit-profil-linkedin` → `optimisation-linkedin`) mais n'a pas d'équivalent pour les CV classiques (Word, PDF). L'objectif est d'ajouter une branche "CV classique" parallèle, invocable par des phrases naturelles ("optimise ce CV", "optimise le CV suivant").

---

## Périmètre

- **Conserver** : `optimisation-linkedin` et `audit-profil-linkedin` inchangés
- **Ajouter** : 3 nouveaux skills dans `skills/cv/`
- **Objectifs** :
  - (A) Améliorer la qualité du contenu d'un CV existant (CAR, mots-clés, accroche)
  - (B) Adapter ce CV pour une offre d'emploi spécifique
  - Les deux en séquence, avec audit optionnel

---

## Architecture globale

```
extraction-pdf / extraction-docx
        ↓
normalisation-profil  ←── point d'entrée commun
        ↓
  ┌─────────────────────────┬──────────────────────────────┐
  │   Pipeline LinkedIn     │   Pipeline CV classique      │
  │                         │                              │
  │  audit-profil-linkedin  │  audit-cv (optionnel)        │
  │         ↓               │         ↓                    │
  │  optimisation-linkedin  │  optimisation-cv             │
  │                         │         ↓                    │
  │                         │  ciblage-cv (optionnel)      │
  └─────────────────────────┴──────────────────────────────┘
                        ↓
          generation-cv-docx / pdf / latex
```

Trois nouveaux skills, rien de modifié dans l'existant. Le schéma YAML `normalisation-profil/references/schema.md` reste la référence unique. `ciblage-cv` ajoute `meta.cible` au bloc `meta` existant (qui contient déjà `meta.source`) — pas de nouveau niveau de schéma.

---

## Skills à créer

### 1. `audit-cv`

**Rôle** : évaluer un profil normalisé sur 6 dimensions propres au CV papier (≠ LinkedIn).

**Emplacement** : `skills/cv/audit-cv/`

**Inputs** :
- Profil YAML normalisé — obligatoire
- Rapport `analyse-marche-emploi` — optionnel (enrichit dimension 4)

**6 dimensions** :

| # | Dimension | Source dans le profil |
|---|---|---|
| 1 | Structure | Sections présentes, équilibre longueur |
| 2 | Qualité des descriptions | `experiences[].realisations[]` — CAR, verbes, métriques |
| 3 | Cohérence narrative | `resume` + `experiences[].poste` + `competences[]` |
| 4 | Pertinence compétences | `competences[]` vs rapport marché si dispo |
| 5 | Accroche/résumé | `identite.resume` — différenciante, orientée valeur |
| 6 | Lisibilité | Densité des bullets, longueur des descriptions |

**Sortie** : rapport YAML `audit_cv:` avec `dimensions[]` (statut OK/Faible/Critique + gaps) et `priorites[]` top 3 — même structure que `audit-profil-linkedin` pour cohérence.

**Modèle** : `claude-sonnet-4-6` (jugement interprétatif requis).

**Référence** : `references/grille-audit-cv.md`

---

### 2. `optimisation-cv`

**Rôle** : améliorer la qualité du contenu d'un CV ; point d'entrée naturel du pipeline classique.

**Emplacement** : `skills/cv/optimisation-cv/`

**Invocation naturelle** : "optimise ce CV", "optimise le CV suivant", "améliore mon CV"

**Gestion des inputs** :

| Input détecté | Comportement |
|---|---|
| Profil YAML normalisé | Optimisation directe |
| Texte brut / CV collé dans la conversation | Invoque `normalisation-profil` → optimise |
| Chemin `.docx` | Invoque `extraction-docx` → `normalisation-profil` → optimise |
| Chemin `.pdf` | Invoque `extraction-pdf` → `normalisation-profil` → optimise |
| Rapport `audit-cv` fourni | Consomme `audit_cv.priorites[]` pour prioriser |
| Rapport `analyse-marche-emploi` fourni | Active l'optimisation des compétences |

**Sans audit** : le skill scanne lui-même le profil (descriptions vagues, métriques nulles, résumé absent) et classe les priorités d'optimisation.

**Sections traitées** :
- `identite.resume` — réécriture de l'accroche (orientée valeur, différenciante)
- `experiences[].realisations[].texte` — reformulation CAR (Contexte → Action → Résultat)
- `experiences[].realisations[].metrique` — extraction/clarification si disponible
- `competences[]` — ajouts/suppressions si rapport marché présent

**Sortie** :
1. **YAML enrichi** — drop-in pour `generation-cv-*`, champs existants réécrit, schéma inchangé
2. **Aperçu textuel** — liste des sections modifiées avec avant/après pour relecture

**Modèle** : `claude-sonnet-4-6`.

**Référence** : `references/sections-cv.md` (guide de rédaction CV classique : accroche, CAR, compétences)

---

### 3. `ciblage-cv`

**Rôle** : adapter un CV optimisé pour une offre d'emploi spécifique.

**Emplacement** : `skills/cv/ciblage-cv/`

**Invocation naturelle** : "cible mon CV pour cette offre", "adapte mon CV pour [poste]"

**Inputs** :
- YAML normalisé ou enrichi — obligatoire
- Offre d'emploi (texte) — obligatoire
- Si input brut (CV non normalisé) → invoque `normalisation-profil` + `optimisation-cv` d'abord

**Process** :
1. Parser l'offre → extraire mots-clés, compétences requises, ton attendu
2. Scorer chaque expérience et réalisation vs l'offre
3. Réordonner `experiences[]` et `realisations[]` par pertinence décroissante
4. Reformuler `identite.resume` pour le poste cible
5. Ajuster `competences[]` selon les termes exacts de l'offre

**Sortie** :
- Bloc YAML ciblé (output de la conversation, distinct du YAML enrichi source — l'utilisateur choisit s'il le sauvegarde) avec `meta.cible: { poste: str, entreprise: str, date: YYYY-MM-DD }`
- Résumé des adaptations : ce qui a été réordonné/reformulé et pourquoi

**Modèle** : `claude-sonnet-4-6`.

**Référence** : `references/analyse-offre.md` (extraction mots-clés, scoring pertinence, règles de réordonnancement)

---

## Références à créer (3 fichiers, ≤ 150 lignes chacun)

| Fichier | Skill | Contenu |
|---|---|---|
| `audit-cv/references/grille-audit-cv.md` | `audit-cv` | 6 dimensions, indicateurs, niveaux OK/Faible/Critique, format de sortie |
| `optimisation-cv/references/sections-cv.md` | `optimisation-cv` | Guide rédaction : accroche CV, format CAR, compétences ATS-friendly |
| `ciblage-cv/references/analyse-offre.md` | `ciblage-cv` | Extraction mots-clés offre, scoring pertinence, règles réordonnancement |

---

## Flux d'invocation typiques

```
"Optimise ce CV"
→ optimisation-cv (auto-détection input, auto-scan faiblesses)

"Optimise ce CV pour cette offre"
→ optimisation-cv → ciblage-cv

"Fais un audit de mon CV"
→ audit-cv seul

"Audit puis optimise"
→ audit-cv → optimisation-cv

"Audit, optimise et cible pour ce poste"
→ audit-cv → optimisation-cv → ciblage-cv → generation-cv-docx
```

---

## Ce qui ne change pas

- `optimisation-linkedin` et `audit-profil-linkedin` : inchangés
- Schéma YAML `normalisation-profil/references/schema.md` : inchangé — `meta.cible` est une extension du bloc `meta` existant, pas une modification du schéma core
- `generation-cv-*` : inchangés — ils consomment le YAML enrichi ou ciblé tel quel
- Convention 150 lignes par référence : respectée
- Langue : français
