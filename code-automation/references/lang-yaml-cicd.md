# YAML — CI/CD (GitHub Actions / GitLab CI)

## Principes

- **Jobs atomiques** : chaque job a une responsabilité claire
- **Fail fast** : les checks rapides (lint, type-check) en premier
- **Secrets via vault** : jamais de credentials en dur dans le YAML
- **Artifacts** : conserver les outputs utiles (rapports de test, binaires)

---

## Exemple GitHub Actions

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: coverage/
```

---

## Checklist pipeline

- [ ] Versions d'actions fixées (`@v4`, pas `@latest`)
- [ ] Cache des dépendances activé
- [ ] Secrets référencés via `${{ secrets.NAME }}`
- [ ] `if: always()` sur l'upload d'artifacts de test
- [ ] Environnements de déploiement avec approbation pour prod
