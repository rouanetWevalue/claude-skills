# Grille de scoring — Pertinence profil × marché cible

## Dimensions évaluées et pondérations

| # | Dimension | Poids | Source dans le profil | Source dans le rapport marché |
|---|---|---|---|---|
| 1 | Compétences techniques | 30 % | `competences[]` (catégorie ≠ Soft skills) | Rapport §3 — compétences indispensables / appréciées |
| 2 | Soft skills | 15 % | `competences[]` catégorie "Soft skills" | Rapport §4 — top 5 soft skills du secteur |
| 3 | Expérience | 25 % | `experiences[]` durée + niveau de responsabilité | Rapport §6 — années médianes, profil type |
| 4 | Formation | 10 % | `formations[]` diplôme + domaine | Rapport §6 — niveau de formation requis |
| 5 | Certifications | 10 % | `certifications[]` | Rapport §3 — certifications fréquemment mentionnées |
| 6 | Narrative / Positionnement | 10 % | `resume` + `realisations[].texte` | Rapport §1 — intitulés de poste équivalents |

**Total : 100 %**

---

## Échelle de scoring par dimension (0 → 100)

| Score | Signification |
|---|---|
| 90–100 | Couverture totale : toutes les attentes marché sont satisfaites, avec des éléments différenciants |
| 70–89 | Couverture solide : l'essentiel est couvert, 1–2 points secondaires manquants |
| 50–69 | Couverture partielle : les fondamentaux sont présents mais des lacunes significatives existent |
| 30–49 | Couverture faible : plusieurs attentes clés du marché ne sont pas adressées |
| 0–29 | Inadéquation majeure : le profil ne correspond pas aux prérequis du segment cible |

**Score global** = somme pondérée des 6 dimensions (ex : dim1 × 0,30 + dim2 × 0,15 + …).

---

## Règles de notation par dimension

### Dimension 1 — Compétences techniques (30 %)
- Compétence "Indispensable" (>70 % des offres) présente dans le profil → +15 pts par compétence (plafonné à 60 pts)
- Compétence "Appréciée" (40–70 %) présente → +8 pts
- Compétence "En déclin" listée dans le profil sans contrepartie récente → -5 pts
- Aucune compétence indispensable couverte → score max 20

### Dimension 2 — Soft skills (15 %)
- Chaque soft skill du top 5 marché présent dans `competences[]` → +20 pts
- Soft skills inférables depuis `realisations[]` (ex : "managé 5 personnes" → leadership) → +10 pts

### Dimension 3 — Expérience (25 %)
- Années d'expérience totales vs médiane marché : écart ≤ 2 ans → 80 pts, > 5 ans → 60 pts (surqualification), < -3 ans → 30 pts
- Responsabilités correspondant au niveau cible → +10 pts
- Expérience dans le secteur exact → +10 pts

### Dimension 4 — Formation (10 %)
- Diplôme requis ou supérieur → 100 pts
- Diplôme inférieur d'un niveau → 60 pts
- Autodidacte avec certifications compensatoires → 50 pts
- Aucun diplôme et aucune certification → 20 pts

### Dimension 5 — Certifications (10 %)
- Certification mentionnée dans le rapport marché présente → 100 pts (une suffit)
- Certification de substitution reconnue → 70 pts
- Aucune certification pertinente → 0 pts

### Dimension 6 — Narrative / Positionnement (10 %)
- `resume` présent, aligné sur l'intitulé cible, différenciant → 100 pts
- `resume` présent mais générique → 50 pts
- `resume` absent ou `null` → 0 pts
- `realisations` avec métriques sur ≥ 50 % des expériences → +10 pts bonus

---

## Format de sortie attendu

```yaml
scoring:
  score_global: 72        # score pondéré 0-100
  dimensions:
    competences_techniques: 78
    soft_skills: 60
    experience: 80
    formation: 100
    certifications: 70
    narrative: 50
  top_3_priorites:
    - priorite: 1
      dimension: soft_skills
      ecart: "Leadership non documenté malgré 3 postes de management"
      action: "Reformuler les réalisations pour faire apparaître le nombre de personnes managées"
    - priorite: 2
      dimension: narrative
      ecart: "Resume générique, pas aligné sur le poste de Product Manager"
      action: "Réécrire le resume avec l'intitulé cible et 1 métrique différenciante"
    - priorite: 3
      dimension: certifications
      ecart: "Certification AWS manquante (mentionnée dans 65 % des offres)"
      action: "Passer AWS Cloud Practitioner comme première étape"
```

---

## Règles universelles

- **Ne jamais inventer** de données absentes du profil ou du rapport marché
- **Citer la source** de chaque pénalité ou bonus significatif (ex : "compétence X absente du profil, indispensable selon rapport §3")
- **Prioriser** les top 3 sur le rapport effort/impact : préférer des actions rapides (reformulation) sur des investissements longs (formation) si le score est proche du seuil
