# Frontend Artifacts — React / Tailwind / HTML

Référence pour la génération de composants et pages depuis une description textuelle
ou une maquette. Complète `lang-web.md` (HTML/CSS/Jinja2) pour les stacks React + Tailwind.

---

## Workflow : description → artefact

```
1. Identifier le composant : type (form, card, list, modal, nav…)
2. Lister les états : loading / empty / error / nominal
3. Définir les props / données attendues
4. Générer la structure HTML sémantique
5. Appliquer le style Tailwind (mobile-first)
6. Ajouter états interactifs (hover, focus, disabled)
7. Vérifier l'accessibilité (aria, labels, contraste)
```

---

## React — Patterns de génération

### Composant fonctionnel de base
```tsx
interface Props {
  title: string
  items: Item[]
  onSelect: (id: string) => void
}

export function ComponentName({ title, items, onSelect }: Props) {
  if (!items.length) return <EmptyState />
  return (
    <div className="...">
      {items.map(item => (
        <Item key={item.id} {...item} onClick={() => onSelect(item.id)} />
      ))}
    </div>
  )
}
```

### États à toujours couvrir

| État | Rendu |
|---|---|
| `loading` | Squelette (`animate-pulse`) ou spinner |
| `empty` | Message explicatif + CTA si applicable |
| `error` | Message + bouton retry |
| `nominal` | Données affichées |

### Conventions de nommage
- Composants : `PascalCase` (`UserCard`, `OrderList`)
- Handlers : `handleVerb` (`handleSubmit`, `handleClose`)
- Booléens : `isLoading`, `hasError`, `isOpen`

---

## Tailwind — Patterns courants

### Grille responsive
```html
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
```

### Carte standard
```html
<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm
            hover:shadow-md transition-shadow">
```

### Bouton primary
```html
<button class="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white
               hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500
               disabled:opacity-50 disabled:cursor-not-allowed">
```

### Input
```html
<input class="block w-full rounded-md border border-gray-300 px-3 py-2 text-sm
              placeholder-gray-400 focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
```

---

## Accessibilité — Règles de base

- `<img>` : toujours un `alt` (vide `alt=""` si purement décoratif)
- Boutons icône uniquement : `aria-label` obligatoire
- `<input>` : `<label>` associé via `htmlFor` / `for`, ou `aria-label`
- La couleur seule ne suffit pas à transmettre une information — ajouter icône ou texte
- Ne jamais supprimer `outline` sans alternative visible au focus

---

## Critères de qualité

- Pas de `style=` inline sauf valeur dynamique impossible en Tailwind
- `className` > 8 utilities → extraire en composant ou variable `const cls = "..."`
- Mobile-first : commencer sans préfixe, surcharger avec `sm:` / `md:` / `lg:`
- Pas de `div` là où un élément sémantique convient (`button`, `nav`, `section`, `article`)
