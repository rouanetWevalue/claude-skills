# Comparaison multi-documents

Objectif : croiser plusieurs documents pour identifier convergences, divergences, complémentarités ou produire une vue unifiée.

---

## Protocole

1. **Lire chaque document en entier** avant de commencer la comparaison
2. **Identifier l'axe de comparaison** : versions d'une même spec ? Sources différentes sur un même sujet ? Avant/après ?
3. **Nommer les documents** clairement dans la réponse : Doc A, Doc B — ou par leur titre si disponible
4. **Ne pas mélanger** les informations sans attribuer leur source

---

## Formats de sortie

### Tableau comparatif (critères précis)

```
| Critère      | [Doc A]          | [Doc B]          | Delta            |
|--------------|------------------|------------------|-----------------|
| Version      | 1.2              | 2.0              | Mise à jour      |
| Périmètre    | Module auth seul | Auth + profils   | Étendu           |
| Date         | 2023-11          | 2024-03          | +4 mois          |
```

### Vue unifiée (fusion de plusieurs sources)

Présenter l'information consolidée, avec en note les points de divergence :

```
**[Sujet]**
[Information consolidée des deux sources]

> ⚠️ Divergence : [Doc A] indique X, [Doc B] indique Y — à clarifier.
```

### Delta entre deux versions

```
**Ajouts dans [Doc B]** :
- [Élément nouveau]

**Suppressions** :
- [Élément présent dans Doc A, absent dans Doc B]

**Modifications** :
- [Élément] : "[ancienne formulation]" → "[nouvelle formulation]"

**Inchangé** : [sections ou points identiques]
```

---

## Signalement des conflits

Si deux documents se contredisent sur un point factuel :
> "**Conflit** : [Doc A] (§X) affirme [A], [Doc B] (§Y) affirme [B]. Ces deux positions sont incompatibles — une clarification est nécessaire."

Ne pas trancher arbitrairement. Signaler, ne pas décider.
