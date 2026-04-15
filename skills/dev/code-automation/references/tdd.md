# TDD & Clean Code

Standards appliqués à tout code testable, quelle que soit la tâche.

---

## TDD

### Le cycle red-green-refactor

```
RED      — écrire le test qui décrit le comportement attendu → il échoue
           ↓ vérifier qu'il échoue pour la bonne raison (pas une erreur de syntaxe)
GREEN    — écrire le code minimal pour le faire passer
           ↓ strictement le minimum — valeur en dur acceptée si ça suffit
REFACTOR — améliorer sans casser les tests
           ↓ supprimer la duplication, clarifier les noms, réduire la complexité
```

**RED — bien écrire le test**
- Tester le **comportement**, pas l'implémentation interne
- Une assertion par test (idéalement)
- Nommer le test en décrivant ce qu'il vérifie : `should_return_404_when_user_not_found`
- Faire échouer le test **avant** d'écrire le code

**GREEN — code minimal**
- Résister à l'envie d'écrire du code "propre" avant que le test passe
- Code dupliqué ou valeur codée en dur → normal, REFACTOR corrigera

**REFACTOR — nettoyer sous filet**
- Supprimer la duplication introduite en GREEN
- Améliorer la lisibilité sans changer le comportement observable
- Les tests qui passent sont le seul filet de sécurité

### Quand appliquer
- **Toujours** pour les fonctions pures, les modules métier, la logique conditionnelle
- **Proposer les cas de test** même si l'utilisateur implémente lui-même
- **Adapter** si le contexte impose du code non-testable (glue code infra, scripts jetables)

### Structure d'un bon test (AAA)
```
// Arrange — préparer les données et le contexte
// Act     — appeler le code testé
// Assert  — vérifier le résultat
```

### Ce qu'un test doit couvrir
- Le cas nominal (happy path)
- Les cas limites (valeur nulle, liste vide, chaîne vide, 0)
- Les cas d'erreur attendus (input invalide, ressource absente)

---

## Test Doubles

Remplacer les dépendances externes pour tester en isolation.

| Type | Comportement | Usage typique |
|---|---|---|
| **Stub** | Retourne des valeurs prédéfinies | Isoler une dépendance sans logique |
| **Mock** | Vérifie les appels et arguments | Tester les interactions (appelé ? avec quoi ?) |
| **Spy** | Enregistre les appels, exécute le réel | Observer sans remplacer |
| **Fake** | Implémentation simplifiée fonctionnelle | DB in-memory, filesystem virtuel |
| **Dummy** | Valeur placeholder, jamais utilisée | Remplir des paramètres obligatoires |

**Règles**
- Préférer les **Fakes** sur les Mocks — moins fragiles aux refactos
- Un Mock qui vérifie >3 interactions = signal que le code fait trop de choses
- Ne pas mocker ce qu'on ne possède pas : API externe → Fake/Adapter d'abord
- Des tests qui mockent tout ne testent rien d'utile

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
