# Architecture First

Obligatoire pour : nouveau script >50 lignes estimées, nouvelle API, nouveau module infra, adaptation maquette complète, toute décision structurelle.

---

## Protocole

### A — Clarification (si ambiguïté bloquante)
Poser au maximum **2 questions** avant de proposer une architecture. Ne pas bloquer sur des détails assumables.

### B — Proposition d'architecture
Présenter **avant tout code** :

```
## Architecture proposée

**Approche** : [2-3 phrases]

**Structure** :
[arborescence ou découpage des responsabilités]

**Décisions clés** :
- [Décision] → [Rationnel]

**Hors scope** :
- [Exclusion explicite]

**Alternative écartée** : [si pertinent]
```

### C — Validation
Attendre une validation explicite ou implicite avant d'implémenter.

### D — Implémentation par blocs
- Découper en blocs logiques avec commentaires d'intention
- Signaler les `TODO` explicitement si quelque chose est volontairement laissé de côté
- Ne pas sur-abstraire : implémenter ce qui est validé, pas ce qui pourrait être utile un jour

---

## Principes de décision d'architecture

- **YAGNI** — ne pas construire ce qui n'est pas demandé
- **Séparation des responsabilités** — chaque module a un rôle unique et clairement nommé
- **Fail fast** — les erreurs doivent être visibles tôt, pas absorbées silencieusement
- **Convention over configuration** — préférer les standards existants du langage/écosystème
- **Évolutivité explicite** — si un point est susceptible de changer, le nommer et l'isoler

---

## Livrables attendus après validation

1. Structure de fichiers / modules
2. Interfaces publiques (signatures de fonctions, schémas d'API, contrats)
3. Flux de données principal
4. Plan de tests (quoi tester en priorité)
