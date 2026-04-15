# Modèle de décision — séquentiel vs parallèle

## Arbre de décision (par paire de tâches)

```
T2 dépend du résultat de T1 ?
├── OUI → séquentiel (T1 puis T2)
└── NON
    ├── T1 et T2 modifient les mêmes fichiers ?
    │   ├── OUI → séquentiel (risque de conflit)
    │   └── NON → parallèle ✓
    └── Total agents en parallèle > 5 ?
        ├── OUI → stagifier (voir ci-dessous)
        └── NON → parallèle ✓
```

**Règle de limite** : maximum **5 agents simultanés** (pression mémoire documentée au-delà).
Si plus de 5 tâches indépendantes → regrouper en étapes (staging).

---

## Plan d'exécution multi-étapes (staging)

Quand toutes les tâches ne peuvent pas être parallèles (dépendances ou limite des 5),
construire un plan en **étapes numérotées**.

**Format du plan d'exécution :**

```
Étape 1 (parallèle) : T1, T2, T3
  → Attendre completion + validation
Étape 2 (parallèle) : T4, T5
  → dépendent de T1 et T2
  → Attendre completion + validation
Étape 3 (séquentiel) : T6
  → dépend de T4 et T5, modifie fichier partagé
```

---

## Exemples par type de tâche

### Investigation (3 hypothèses indépendantes)
```
Étape 1 (parallèle) : H1-réseau, H2-base-de-données, H3-cache
→ Synthèse des findings par l'orchestrateur
→ Si une hypothèse confirmée → Étape 2
Étape 2 (séquentiel) : T-correctif (dépend du finding de l'étape 1)
```

### Feature (couches dépendantes)
```
Étape 1 (parallèle) : T-modèle-données, T-tests-unitaires-spec
→ Les deux peuvent s'écrire sans se bloquer
Étape 2 (séquentiel) : T-service (dépend du modèle)
Étape 3 (séquentiel) : T-contrôleur (dépend du service)
Étape 4 (parallèle) : T-tests-intégration, T-documentation
```

### Audit (dimensions indépendantes)
```
Étape 1 (parallèle, max 5) : audit-sécurité, audit-perf, audit-maintenabilité, audit-accessibilité
→ Pas de dépendances croisées — tout en parallèle
```

---

## Critères de regroupement en une étape

Regrouper des tâches en séquentiel si :
- Elles partagent un fichier de sortie (conflit)
- L'une utilise un symbole/interface défini par l'autre
- Elles font partie du même flux métier atomique

Garder en parallèle si :
- Périmètres fichiers totalement disjoints
- Résultats indépendants (chacun produit son propre livrable)
- Pas de variable d'état partagée pendant l'exécution

---

## Format de sortie attendu

Après application du modèle, produire :

```
Plan d'exécution — [Nom du problème]

Étape 1 | parallèle | agents : 3
  - [T1] description — périmètre — modèle
  - [T2] description — périmètre — modèle
  - [T3] description — périmètre — modèle

Étape 2 | séquentiel | dépend de : T1
  - [T4] description — périmètre — modèle

Revue automatique : oui / non (bypass : [raison si bypass])
```
