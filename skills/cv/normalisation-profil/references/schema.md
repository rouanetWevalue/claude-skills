# Schéma standard de profil normalisé

Format cible : YAML. Toujours produire ce schéma complet, même si des champs sont vides (valeur `null`).

```yaml
profil:
  meta:
    source: string          # "pdf" | "docx" | "linkedin" | "manuel"
    date_extraction: string # YYYY-MM-DD
    langue_profil: string   # "fr" | "en" | ...
    version: "1.0"

  identite:
    nom: string
    prenom: string
    titre: string           # ex: "Data Engineer | Python | AWS"
    email: string
    telephone: string
    localisation: string    # Ville, Pays
    linkedin_url: string
    github_url: string
    portfolio_url: string
    site_web: string

  resume: string            # Texte libre, 3–5 phrases

  experiences:
    - entreprise: string
      poste: string
      type_contrat: string  # CDI | CDD | Freelance | Stage | Alternance | Bénévolat
      date_debut: string    # YYYY-MM
      date_fin: string      # YYYY-MM | "présent"
      localisation: string
      description: string
      realisations:
        - texte: string     # Format CAR : Contexte → Action → Résultat
          metrique: string  # ex: "+35% de performance", "économie de 20k€/an"
      competences_utilisees: [string]

  formations:
    - etablissement: string
      diplome: string       # ex: "Master", "Licence", "MBA", "Bac+5"
      domaine: string
      date_debut: string    # YYYY-MM
      date_fin: string      # YYYY-MM
      mention: string
      description: string

  competences:
    - nom: string
      niveau: string        # Débutant | Intermédiaire | Avancé | Expert
      categorie: string     # Langages | Frameworks | Cloud | Outils | Méthodes | Soft skills

  langues:
    - langue: string
      niveau: string        # Natif | Courant (C1-C2) | Professionnel (B2) | Scolaire (A1-B1)

  certifications:
    - nom: string
      organisme: string
      date: string          # YYYY-MM
      expiration: string    # YYYY-MM | "aucune"
      url: string

  projets:
    - nom: string
      description: string
      url: string
      technologies: [string]
      realisations: [string]

  publications:
    - titre: string
      support: string       # ex: "Medium", "LinkedIn Article", "Conférence"
      date: string          # YYYY-MM
      url: string

  distinctions:
    - titre: string
      organisme: string
      date: string          # YYYY-MM

  centres_interet: [string]
```

## Règles de remplissage

- Champ absent du document source → `null` (ne pas inventer)
- Dates partielles → compléter avec `01` pour le mois si seule l'année est connue
- `realisations[].metrique` → extraire ou inférer depuis le texte si possible, sinon `null`
- `competences[].niveau` → inférer depuis le contexte (années d'utilisation, certifications)
- `type_contrat` → inférer depuis le contexte si non explicite (ex: titre "Consultant" → "Freelance")
