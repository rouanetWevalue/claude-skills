# Template Markdown — CV

## Règles typographiques

- Titres de section : `## NOM DE SECTION` (H2, majuscules)
- Sous-titres (poste/diplôme) : `### Titre du poste — Entreprise` (H3)
- Séparateur entre expériences : ligne vide (pas de `---`)
- Dates : format `MMM YYYY – MMM YYYY` ou `MMM YYYY – présent`
- Bullets de réalisations : tiret simple `- ` (pas `*`)
- Gras **`**texte**`** pour les métriques et mots-clés techniques
- Italique `_texte_` pour les mentions, distinctions, niveaux de langue
- Longueur cible : 1 page A4 = ~500–700 mots de contenu texte

---

## Structure complète du template

```markdown
# {prenom} {nom}
**{titre}**

{email} | {telephone} | {localisation}
[LinkedIn]({linkedin_url}) | [GitHub]({github_url}) | [{site_web}]({site_web})

---

## RÉSUMÉ

{resume}

---

## EXPÉRIENCES PROFESSIONNELLES

### {poste} — {entreprise}
_{type_contrat} · {localisation} · {date_debut} – {date_fin}_

- {realisation_1}
- {realisation_2}

**Compétences mobilisées :** {competences_utilisees}

### {poste} — {entreprise}
...

---

## FORMATIONS

### {diplome} en {domaine} — {etablissement}
_{date_debut} – {date_fin} · {mention}_

{description}

---

## COMPÉTENCES

**{categorie_1} :** {competences}
**{categorie_2} :** {competences}

---

## LANGUES

- {langue} : _{niveau}_

---

## CERTIFICATIONS

- **{nom}** — {organisme}, {date}

---

## PROJETS

### {nom}
{description} — [Lien]({url})
Technologies : {technologies}

---

## PUBLICATIONS

- **{titre}** — _{support}_, {date} — [Lien]({url})

---

## DISTINCTIONS

- **{titre}** — {organisme}, {date}

---

## CENTRES D'INTÉRÊT

{centres_interet}
```

---

## Bullets CAR — Format et exemples

**Formule** : Contexte → Action → Résultat (mettre la métrique en gras)

### Mode classique (séquentiel)
```
- Refonte du pipeline ETL legacy (contexte) : migration vers Airflow +
  dbt (action) → **réduction de 40 % du temps de traitement** (résultat)
- Animation d'ateliers de formation pour 12 développeurs (action) →
  **adoption de 100 % des pratiques CI/CD** en 3 mois (résultat)
```

### Mode orienté poste (impact en tête)
Inverser l'ordre : Résultat → Action → Contexte. Mettre la réalisation
la plus alignée avec l'offre en premier bullet.
```
- **+35 % de performance** obtenu en remodélisant le schéma de données
  (Snowflake) pour un lac de données 2 To (offre : Data Engineer senior)
- **Économie de 20 k€/an** : automatisation du déploiement Terraform sur
  AWS, remplaçant 8 h de manipulation manuelle hebdomadaire
```

---

## Section "Compétences clés pour le poste" (mode orienté poste uniquement)

À insérer juste après le résumé, avant les expériences :

```markdown
## COMPÉTENCES CLÉS POUR LE POSTE

| Requis dans l'offre | Niveau candidat |
|---|---|
| Python / Pandas | Expert — 6 ans, projets data industriels |
| AWS (S3, Lambda, Glue) | Avancé — certification AWS SAA |
| dbt | Intermédiaire — 2 projets en production |
```

Construire ce tableau à partir des `competences_utilisees` des expériences
et des `competences[]` du profil, en croisant avec les mots-clés de l'offre.

---

## Règles de rendu par section du schéma profil

Toute section dont la valeur est `null` ou la liste vide `[]` est omise
silencieusement. Les liens optionnels (`github_url`, `linkedin_url`,
`portfolio_url`, `site_web`) sont omis si `null`.
