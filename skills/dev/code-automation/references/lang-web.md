# HTML / CSS / Jinja2

---

## HTML

### Principes

- **Sémantique** : utiliser les balises pour leur sens (`<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`)
- **Accessibilité** : `alt` sur les images, `aria-label` sur les icônes, structure de titres cohérente (h1 → h2 → h3)
- **Responsive** : `<meta name="viewport">`, unités relatives (`rem`, `%`, `vw`)

### Structure de base

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Titre de la page</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <header>...</header>
  <main>
    <section aria-labelledby="section-title">
      <h2 id="section-title">Titre de section</h2>
      ...
    </section>
  </main>
  <footer>...</footer>
</body>
</html>
```

---

## CSS

### Organisation (par ordre dans le fichier)

```css
/* 1. Variables / Design tokens */
:root {
  --color-primary: #2563eb;
  --color-text: #1f2937;
  --spacing-base: 1rem;
  --radius-md: 0.375rem;
}

/* 2. Reset / Base */
*, *::before, *::after { box-sizing: border-box; }

/* 3. Layout */
.container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; }

/* 4. Composants */
.card { ... }

/* 5. Utilitaires (si pas de framework) */
.sr-only { ... }
```

### Convention de nommage (BEM ou convention existante)

```css
/* BEM : Block__Element--Modifier */
.card { }
.card__title { }
.card__body { }
.card--featured { }

/* Ou convention du projet en place — ne pas en changer une sans raison explicite */
```

### Responsive

```css
/* Mobile-first */
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--spacing-base);
}

@media (min-width: 768px) {
  .grid { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 1024px) {
  .grid { grid-template-columns: repeat(3, 1fr); }
}
```

---

## Jinja2

### Bonnes pratiques

```jinja
{# Commentaires Jinja — ne pas exposer la logique dans les templates #}

{# Filtres utiles #}
{{ name | title }}
{{ description | truncate(100) }}
{{ price | round(2) }}

{# Macros pour les composants réutilisables #}
{% macro button(label, type="button", class="") %}
  <button type="{{ type }}" class="btn {{ class }}">
    {{ label }}
  </button>
{% endmacro %}

{# Héritage — structure recommandée #}
{# base.html.j2 #}
<!DOCTYPE html>
<html>
<head>{% block head %}<title>{% block title %}{% endblock %}</title>{% endblock %}</head>
<body>{% block content %}{% endblock %}</body>
</html>

{# page.html.j2 #}
{% extends "base.html.j2" %}
{% block title %}Ma page{% endblock %}
{% block content %}
  <h1>Contenu</h1>
{% endblock %}
```

### Sécurité

- Autoescaping activé (`autoescape=True`) pour tout contenu HTML généré
- Ne jamais injecter du contenu utilisateur non filtré avec `| safe`
- Variables de config/secrets injectées via le contexte, pas depuis les templates

---

## Adaptation de maquettes Figma

Workflow lors d'une adaptation :

1. **Analyser** la maquette : layout, composants, états (hover, focus, disabled), breakpoints
2. **Extraire** le design system implicite : palette de couleurs, espacements récurrents, typographie
3. **Déclarer** les design tokens en variables CSS (`--color-*`, `--spacing-*`, `--font-*`)
4. **Structurer** en composants HTML avant d'écrire le CSS
5. **Tester** les états interactifs et la version mobile
