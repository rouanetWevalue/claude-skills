# Extraction de données

Objectif : récupérer des informations précises depuis un document et les restituer dans un format structuré.

---

## Protocole

1. **Identifier le format de sortie attendu** : liste, tableau, JSON, paires clé-valeur
2. **Lire le document en entier** avant d'extraire — ne pas s'arrêter au premier résultat trouvé
3. **Être exhaustif** : ne pas filtrer silencieusement des entrées qui semblent moins importantes
4. **Signaler les ambiguïtés** : si une valeur est incertaine, la marquer `[?]`
5. **Signaler les absences** : si un champ demandé est absent du document, le noter explicitement

---

## Formats de sortie

### Tableau Markdown (données comparables)
```
| Champ       | Valeur        | Source (section/page) |
|-------------|---------------|----------------------|
| Date        | 2024-03-15    | En-tête, p.1         |
| Responsable | J. Dupont     | §3.2                 |
```

### JSON (données structurées pour traitement)
```json
{
  "date": "2024-03-15",
  "responsable": "J. Dupont",
  "montant": null,
  "_notes": "Montant absent du document"
}
```

### Liste à puces (éléments homogènes)
- Item 1 (§2.1)
- Item 2 (§2.3)
- [?] Item ambigu — formulation exacte : "..."

---

## Cas particuliers

**Document scanné / mauvaise qualité** : signaler si des parties sont illisibles, ne pas deviner.

**Tableaux complexes** : reconstruire fidèlement — ne pas simplifier les en-têtes ou fusionner des cellules.

**Données dans plusieurs langues** : restituer dans la langue du document sauf instruction contraire.
