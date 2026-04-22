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
