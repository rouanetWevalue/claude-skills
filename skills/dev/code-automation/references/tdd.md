# TDD & Clean Code

Standards appliqués à tout code testable, quelle que soit la tâche.

---

## TDD

### Le cycle

```
1. RED   — écrire le test qui décrit le comportement attendu → il échoue
2. GREEN — écrire le code minimal pour le faire passer
3. REFACTOR — améliorer sans casser les tests
```

### Quand appliquer
- **Toujours** pour les fonctions pures, les modules métier, les scripts avec logique conditionnelle
- **Proposer les cas de test** même si l'utilisateur implémente lui-même
- **Adapter** si le contexte impose du code non-testable (glue code infra, scripts jetables)

### Structure d'un bon test
```
// Arrange — préparer les données et le contexte
// Act     — appeler le code testé
// Assert  — vérifier le résultat
```

### Ce qu'un test doit couvrir
- Le cas nominal (happy path)
- Les cas limites (valeur nulle, liste vide, chaîne vide)
- Les cas d'erreur attendus (input invalide, ressource absente)

---

## Clean Code

### Nommage
- Noms **expressifs** : `getUserById` pas `getU`, `isEmailValid` pas `check`
- Pas d'abréviations sauf conventions universelles (`id`, `url`, `ctx`, `req`, `res`)
- Fonctions : verbe + complément (`parseConfig`, `sendNotification`)
- Booléens : préfixe `is` / `has` / `can` / `should`

### Fonctions
- **Responsabilité unique** : une fonction fait une chose
- Longueur idéale : <20 lignes (signal d'alerte, pas règle absolue)
- Pas de paramètres booléens (`doSomething(true)` → deux fonctions distinctes)
- Pas d'effets de bord cachés

### Commentaires
- Commenter le **pourquoi**, jamais le **quoi**
- Un bon nom de fonction remplace 90% des commentaires
- Les `TODO` doivent être datés et précis : `// TODO(2024-01): remplacer par l'API v2 quand dispo`

### Gestion des erreurs
- Toujours explicite : pas de `catch` vide, pas d'erreur avalée
- Retourner des erreurs typées ou des messages informatifs
- Ne jamais laisser le programme continuer dans un état incohérent

### Sécurité par défaut
- Pas de secrets en dur (utiliser des variables d'environnement)
- Valider les inputs dès l'entrée
- Principe du moindre privilège dans les configs infra
