# JavaScript / Node.js

---

## Conventions de base

- **Modules** : ESM (`import/export`) par défaut — CommonJS uniquement si le contexte l'impose
- **Variables** : `const` par défaut, `let` si mutation nécessaire, jamais `var`
- **Async** : `async/await` plutôt que `.then()` — sauf chaînage court et lisible
- **Erreurs** : `try/catch` explicite, jamais de `.catch(() => {})` vide

## Structure de projet Node.js

```
src/
├── index.js          ← point d'entrée
├── config/           ← chargement et validation de la config
├── lib/              ← logique métier (pur, testable)
├── services/         ← intégrations externes (API, DB)
├── utils/            ← fonctions utilitaires génériques
└── __tests__/        ← tests unitaires et d'intégration
```

## Gestion des erreurs

```js
// Erreur typée — préférer aux strings
class AppError extends Error {
  constructor(message, code) {
    super(message)
    this.code = code
    this.name = 'AppError'
  }
}

// Async avec contexte
async function fetchUser(id) {
  try {
    const user = await db.find(id)
    if (!user) throw new AppError(`User ${id} not found`, 'NOT_FOUND')
    return user
  } catch (err) {
    // Ne pas avaler : propager ou logger + propager
    logger.error({ err, userId: id }, 'fetchUser failed')
    throw err
  }
}
```

## Configuration

```js
// config/index.js — valider à l'entrée, pas partout dans le code
const config = {
  port: parseInt(process.env.PORT ?? '3000', 10),
  dbUrl: requireEnv('DATABASE_URL'),
}

function requireEnv(key) {
  const val = process.env[key]
  if (!val) throw new Error(`Missing required env var: ${key}`)
  return val
}
```

## Tests (Jest / Vitest)

```js
describe('parseConfig', () => {
  it('retourne la config par défaut si aucune variable', () => {
    // Arrange
    delete process.env.PORT
    // Act
    const config = parseConfig()
    // Assert
    expect(config.port).toBe(3000)
  })

  it('lève une erreur si DATABASE_URL est absent', () => {
    delete process.env.DATABASE_URL
    expect(() => parseConfig()).toThrow('Missing required env var: DATABASE_URL')
  })
})
```

## API REST (Express / Fastify)

- Routes dans `routes/`, logique dans `services/`
- Validation des inputs à l'entrée de chaque route (Zod, Joi, ou JSON Schema)
- Middleware d'erreur centralisé
- Pas de logique métier dans les handlers

## Notes

- Typage : préférer TypeScript pour tout projet >1 fichier ou >1 contributeur
- Logging : utiliser `pino` ou `winston`, pas `console.log` en prod
- Dépendances : vérifier la taille et la maintenance avant d'ajouter un package
