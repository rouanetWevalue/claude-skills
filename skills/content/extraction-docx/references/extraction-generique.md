# Extraction DOCX/PPT — Document générique

Objectif : lire un fichier DOCX ou PPT non-CV et produire un objet structuré (YAML ou JSON) adapté au type de document détecté.

---

## Protocole d'extraction

1. **Identifier le type de document** depuis le titre, les styles, la structure des slides ou le contenu
2. **Choisir le format de sortie** adapté au type détecté (voir tableaux ci-dessous)
3. **Lire le document en intégralité** avant d'extraire — ne pas s'arrêter à la première section ou slide
4. **Exploiter la structure** : styles Word (Titre 1/2/3) et titres de slides PPT comme indicateurs de sections
5. **Signaler les ambiguïtés** avec `[?]` et la formulation source exacte
6. **Signaler les absences** : champ attendu mais absent → `null`

---

## Spécificités DOCX

### Hiérarchie à exploiter
- **Titre 1 / Heading 1** → section principale → clé de premier niveau
- **Titre 2 / Heading 2** → sous-section → clé de second niveau
- **Corps de texte** → contenu de la section courante
- **Tableau** → extraire ligne par ligne avec les en-têtes de colonnes comme clés

### En-têtes, pieds de page et zones flottantes
- Inclure le contenu des en-têtes/pieds de page (souvent : date, auteur, version, numéro de document)
- Inclure le contenu des zones de texte flottantes (souvent : encadrés, notes marginales)

---

## Spécificités PPT

### Structure par slide
- Chaque slide = une unité logique
- Titre de slide → label de la section extraite
- Zones de texte, listes à puces, notes de slide → contenu de la section

### Notes de présentation
- Les notes sous les slides contiennent souvent des informations détaillées absentes du slide
- Les inclure dans l'extraction (champ `notes` associé à la slide)

---

## Types de documents et schémas adaptés

### Rapport / Note de synthèse (DOCX)

```yaml
rapport:
  titre: string
  auteur: string
  date: string              # YYYY-MM-DD
  version: string
  destinataires: [string]
  resume_executif: string
  sections:
    - titre: string
      niveau: number        # 1 = Titre 1, 2 = Titre 2
      contenu: string
      points_cles: [string]
  conclusions: [string]
  recommandations: [string]
  annexes: [string]
```

### Présentation (PPT)

```yaml
presentation:
  titre: string
  auteur: string
  date: string
  contexte: string
  slides:
    - numero: number
      titre: string
      contenu: [string]     # liste des éléments textuels de la slide
      notes: string
  messages_cles: [string]
  conclusions: [string]
```

### Contrat / Document juridique (DOCX)

```yaml
contrat:
  type: string
  parties:
    - nom: string
      role: string
  date_signature: string
  date_debut: string
  date_fin: string
  objet: string
  clauses_cles: [string]
  montant: string
  conditions_resiliation: string
```

---

## Format de sortie par défaut

Si le type ne correspond à aucun schéma ci-dessus :

```yaml
document:
  type: string
  format: string            # "docx" | "pptx" | "doc" | "ppt"
  titre: string
  auteur: string
  date: string
  sections:
    - titre: string
      contenu: string
  metadonnees:
    langue: string
    pages_ou_slides: number
```

---

## Règles universelles

- **Champ absent** → `null`
- **Valeur ambiguë** → `"[?] formulation exacte"`
- **Montants** : toujours inclure la devise
- **Dates** : YYYY-MM-DD ; partiel → YYYY-MM ou YYYY
