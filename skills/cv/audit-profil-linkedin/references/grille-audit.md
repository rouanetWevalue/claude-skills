# Grille d'audit LinkedIn — 6 dimensions

## Vue d'ensemble

| # | Dimension | Évaluable depuis YAML | Source externe |
|---|---|---|---|
| 1 | Complétude | Oui | — |
| 2 | Qualité des descriptions | Oui | — |
| 3 | Cohérence narrative | Oui | Rapport marché §1 (optionnel) |
| 4 | Pertinence compétences vs marché | Partiellement | Rapport scoring (optionnel) |
| 5 | Headline et résumé | Oui | — |
| 6 | Signaux LinkedIn spécifiques | Partiellement | Vérification manuelle requise |

---

## Dimension 1 — Complétude

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| `identite` (nom, titre, localisation) | Tous présents | 1 champ `null` | Titre absent |
| `resume` | Présent, ≥ 3 phrases | < 3 phrases | `null` |
| `experiences[]` | ≥ 1 avec dates + réalisations | Dates ou réalisations manquantes | `null` ou liste vide |
| `competences[]` | ≥ 5 entrées catégorisées | 1–4 entrées | `null` ou liste vide |
| `formations[]` | ≥ 1 avec diplôme + date | Données partielles | `null` ou liste vide |
| `certifications[]` | Présentes si ≥ 3 ans d'exp. | Absentes avec exp. significative | — |

---

## Dimension 2 — Qualité des descriptions d'expérience

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Format CAR | ≥ 70 % des réalisations CAR | 30–69 % en CAR | < 30 % en CAR |
| Métriques | ≥ 1 métrique par expérience | Métriques sur < 50 % des expériences | Aucune métrique (`metrique: null` partout) |
| Descriptions vagues | Aucune ("responsable de", "géré") | 1–2 occurrences | ≥ 3 occurrences |
| Nombre de réalisations | ≥ 2 par expérience récente | 1 seule par expérience | `realisations: []` sur exp. récentes |

> Expériences "récentes" = les 3 dernières ou les 5 dernières années.

---

## Dimension 3 — Cohérence de la narrative

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Fil conducteur | Progression lisible (titre → postes) | Rupture partielle (1 poste hors trajectoire) | Trajectoire incohérente ou contradictoire |
| Alignement titre / expériences | Titre reflète les postes récents | Titre générique sans lien explicite | Titre contredit les postes récents |
| Cohérence compétences / expériences | Compétences retrouvables dans `competences_utilisees` | < 50 % couverture croisée | Compétences déclarées absentes de toutes les expériences |
| Gaps temporels | Aucun gap > 6 mois non expliqué | 1 gap non justifié | ≥ 2 gaps non justifiés ou gap > 1 an |

---

## Dimension 4 — Pertinence des compétences vs marché

> **Prérequis** : rapport scoring-pertinence-profil disponible.
> Si absent → statut `non_evalue` pour cette dimension.

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Score compétences techniques (rapport scoring) | ≥ 70 | 50–69 | < 50 |
| Score soft skills (rapport scoring) | ≥ 70 | 50–69 | < 50 |
| Compétences "En déclin" sans contrepartie | Aucune | 1 compétence | ≥ 2 compétences |
| Compétences indispensables manquantes | Aucune | 1 absente | ≥ 2 absentes |

---

## Dimension 5 — Headline et résumé

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| Headline (`identite.titre`) | Clair, différenciant, intitulé + 2 spécialités | Générique ("Développeur", "Manager") | Absent (`null`) |
| Longueur du résumé | 3–5 phrases, accroche + valeur + CTA | Trop court (1–2 ph.) ou trop long (> 6 ph.) | Absent ou copié-collé de l'expérience |
| Différenciation | Angle unique (spécialité, impact, secteur) | Formulation standard sans angle | Aucun élément différenciant |
| Mots-clés métier | ≥ 3 mots-clés du secteur dans le résumé | 1–2 mots-clés | Aucun mot-clé sectoriel |

---

## Dimension 6 — Signaux LinkedIn spécifiques

> Partiellement évaluable depuis le YAML. Les indicateurs marqués ★ nécessitent une vérification manuelle.

| Indicateur | OK | Faible | Critique |
|---|---|---|---|
| URL personnalisée (`identite.linkedin_url`) | URL custom (linkedin.com/in/prenom-nom) | URL auto-générée avec chiffres | Absent (`null`) |
| Photo de profil ★ | Photo professionnelle présente | Photo informelle | Absente |
| Recommandations ★ | ≥ 2 recommandations reçues | 1 recommandation | Aucune |
| Activité récente ★ | Posts ou partages dans les 3 derniers mois | Activité ancienne (> 6 mois) | Aucune activité visible |
| `identite.linkedin_url` renseigné | Présent et non `null` | — | `null` |

---

## Format de sortie attendu

```yaml
audit:
  dimensions:
    completude:
      statut: Faible          # OK | Faible | Critique
      indicateurs_defaillants:
        - champ: certifications
          observation: "Aucune certification listée malgré 8 ans d'expérience tech"
    qualite_descriptions:
      statut: Critique
      indicateurs_defaillants:
        - champ: metriques
          observation: "0 métrique sur 5 expériences — réalisations toutes sans chiffres"
    coherence_narrative:
      statut: OK
      indicateurs_defaillants: []
    pertinence_competences:
      statut: non_evalue       # si rapport scoring absent
      indicateurs_defaillants: []
    headline_resume:
      statut: Faible
      indicateurs_defaillants:
        - champ: identite.titre
          observation: "Headline générique : 'Ingénieur logiciel' sans spécialité"
    signaux_linkedin:
      statut: Faible
      indicateurs_defaillants:
        - champ: linkedin_url
          observation: "URL auto-générée avec chiffres (vérification manuelle requise)"
        - champ: recommandations
          observation: "Non évaluable depuis YAML — vérification manuelle requise"
  priorites:
    - priorite: 1
      dimension: qualite_descriptions
      gap: "Absence totale de métriques sur toutes les expériences"
      action: "Ajouter au moins 1 métrique par expérience (%, €, délai, volumétrie)"
    - priorite: 2
      dimension: headline_resume
      gap: "Headline non différenciant"
      action: "Reformuler avec intitulé cible + 2 spécialités distinctives"
    - priorite: 3
      dimension: completude
      gap: "Certifications absentes"
      action: "Ajouter les certifications existantes ou planifier une certification clé"
```
