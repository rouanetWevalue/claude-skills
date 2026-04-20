# Extraction PDF — Document générique

Objectif : lire un PDF non-CV et produire un objet structuré (YAML ou JSON) adapté au type de document détecté.

---

## Protocole d'extraction

1. **Identifier le type de document** depuis l'en-tête, le titre, la mise en page ou le contenu
2. **Choisir le format de sortie** adapté (voir tableau ci-dessous)
3. **Lire le document en intégralité** avant d'extraire
4. **Être exhaustif** : ne pas filtrer les entrées qui semblent mineures sans instruction explicite
5. **Signaler les ambiguïtés** avec `[?]` et la formulation source exacte
6. **Signaler les absences** : champ attendu mais absent → `null` avec note

---

## Types de documents et schémas adaptés

### Contrat / Accord

```yaml
contrat:
  type: string          # "CDI" | "Prestation" | "NDA" | "Bail" | autre
  parties:
    - nom: string
      role: string      # "Employeur" | "Prestataire" | "Client" | autre
  date_signature: string  # YYYY-MM-DD
  date_debut: string
  date_fin: string        # null si indéterminé
  objet: string
  clauses_cles: [string]
  montant: string         # avec devise
  conditions_resiliation: string
```

### Facture

```yaml
facture:
  numero: string
  date_emission: string   # YYYY-MM-DD
  date_echeance: string
  emetteur:
    nom: string
    adresse: string
    siret: string
  destinataire:
    nom: string
    adresse: string
  lignes:
    - description: string
      quantite: number
      prix_unitaire: string
      total: string
  total_ht: string
  tva: string
  total_ttc: string
```

### Rapport / Note de synthèse

```yaml
rapport:
  titre: string
  auteur: string
  date: string            # YYYY-MM-DD
  destinataires: [string]
  resume_executif: string
  sections:
    - titre: string
      points_cles: [string]
  conclusions: [string]
  recommandations: [string]
  annexes: [string]
```

### Fiche technique / Spécification

```yaml
fiche_technique:
  produit: string
  version: string
  date: string
  caracteristiques:
    - nom: string
      valeur: string
      unite: string
  contraintes: [string]
  compatibilites: [string]
  references_normatives: [string]
```

---

## Règles universelles

- **Champ absent** → `null` (ne pas inventer ni interpoler)
- **Valeur ambiguë** → `"[?] formulation exacte"`
- **Montants** : toujours inclure la devise (€, $, etc.)
- **Dates** : format YYYY-MM-DD ; si seul le mois/année est donné → YYYY-MM ; si seule l'année → YYYY
- **Documents multi-pages** : extraire la globalité, ne pas s'arrêter à la première page

---

## Format de sortie par défaut

Si le type de document ne correspond à aucun des schémas ci-dessus, produire :

```yaml
document:
  type: string            # Type inféré depuis le contenu
  titre: string
  date: string
  auteur: string
  contenu_structure:
    - section: string
      contenu: string
  metadonnees:
    langue: string
    pages: number
```
