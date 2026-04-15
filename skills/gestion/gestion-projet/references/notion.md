# Notion

---

## Opérations disponibles

| Action | Quand l'utiliser |
|---|---|
| `notion-search` | Trouver une page, base de données ou contenu existant |
| `notion-fetch` | Lire le contenu complet d'une page ou base |
| `notion-create-pages` | Créer une nouvelle page ou entrée dans une base |
| `notion-update-page` | Modifier le contenu ou les propriétés d'une page existante |
| `notion-create-comment` | Ajouter un commentaire sur une page |
| `notion-get-users` | Identifier les membres du workspace pour les mentions ou assignations |

---

## Protocole standard

### Avant de créer
1. Rechercher si la page/entrée existe déjà (`notion-search`)
2. Identifier la base de données cible et son schéma (`notion-fetch`)
3. Résumer ce qui va être créé → attendre validation
4. Créer

### Avant de modifier
1. Lire la page actuelle (`notion-fetch`)
2. Identifier exactement ce qui change
3. Résumer les modifications → attendre validation
4. Mettre à jour

---

## Formats de contenu Notion

### Page standard
```
Titre : [titre clair et descriptif]
Propriétés : [selon le schéma de la base]

Contenu :
## Contexte
[pourquoi cette page existe]

## Contenu principal
[...]

## Actions / Next steps
- [ ] Action 1 — @responsable
- [ ] Action 2
```

### Entrée dans une base de données
Respecter **strictement** le schéma existant :
- Ne pas créer de nouvelles propriétés sans demande explicite
- Utiliser les valeurs de select/multi-select existantes
- Dater les entrées si un champ date est disponible

---

## Bonnes pratiques

- Toujours utiliser la **langue du workspace** (détecter sur les pages existantes)
- Préférer les **liens internes** (`notion-fetch` pour récupérer les IDs) aux mentions textuelles
- Ne pas dupliquer l'information : vérifier avant de créer
