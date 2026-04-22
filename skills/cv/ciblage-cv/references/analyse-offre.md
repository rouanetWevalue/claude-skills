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
