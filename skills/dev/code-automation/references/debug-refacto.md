# Debug & Refactoring

---

## Debug

### Protocole

1. **Lire le code et l'erreur en entier** avant de suggérer quoi que ce soit
2. **Reproduire mentalement** le flux d'exécution jusqu'au point de rupture
3. **Identifier la cause racine**, pas seulement le symptôme visible
4. **Proposer le fix minimal** qui résout le problème sans réécrire
5. **Signaler** si le bug révèle un problème structurel plus large (sans imposer un refacto non demandé)

### Format de réponse debug

```
**Cause identifiée** : [explication en 1-2 phrases]

**Fix** :
[code]

**Vérification** : [comment confirmer que c'est résolu]

**Note** (si pertinent) : [problème structurel sous-jacent à surveiller]
```

### Pièges fréquents à vérifier

- Mutation d'état inattendue (objets passés par référence)
- Gestion async/await manquante ou mal placée
- Conditions de course (race conditions)
- Variables d'environnement absentes ou mal nommées
- Différences de comportement dev/prod (paths, encodage, timezone)

---

## Refactoring

### Principes

- **Scope discipline** : ne refactoriser que ce qui est demandé
- **Comportement préservé** : le refacto ne change pas le comportement observable (sauf si c'est l'objectif explicite)
- **Justifier** chaque changement structurel
- **Tests d'abord** : si les tests n'existent pas, les écrire avant de refactoriser

### Quand refactoriser
- Code dupliqué (DRY)
- Fonction trop longue ou à responsabilités multiples
- Noms trompeurs ou trop vagues
- Complexité cyclomatique élevée (trop de `if` imbriqués)
- Couplage fort entre modules qui devraient être indépendants

### Format de réponse refacto

```
**Problème identifié** : [ce qui justifie le refacto]

**Changements** :
- [Changement 1] → [Rationnel]
- [Changement 2] → [Rationnel]

[code refactorisé]

**Tests à mettre à jour** : [liste si applicable]
```

### Ce que le refacto ne doit pas faire

- Introduire des abstractions non nécessaires (over-engineering)
- Changer les interfaces publiques sans signalement
- Modifier du code hors scope "tant qu'on y est"
