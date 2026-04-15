# Optimisation de la description YAML (CSO)

## Rôle de la description

La `description:` n'est **pas** lue par l'utilisateur — elle est lue par le **moteur de sélection**
du skill. C'est lui qui décide d'invoquer le skill ou non.

Une mauvaise description → skill jamais invoqué même si parfaitement conçu.

---

## Structure obligatoire

```yaml
description: >
  Use when [condition principale d'activation].
  Triggers: [liste de synonymes, formulations alternatives, mots-clés].
  Ce skill couvre : [domaine 1], [domaine 2], [domaine 3].
  NE PAS utiliser pour [cas d'exclusion explicite si pertinent].
```

---

## Règles de rédaction

**1. Commencer par "Use when" ou "Utiliser quand"**
Le moteur lit les premiers mots en priorité. Une description qui commence par le nom
du skill ou une explication fonctionnelle sera moins bien discriminée.

**2. Couvrir les synonymes et formulations alternatives**
L'utilisateur ne connaît pas le nom de ton skill. Il dira "je veux créer un skill",
"nouveau skill", "skill builder", "créer une commande Claude", etc.
Lister les variantes dans `Triggers:`.

**3. Ne pas résumer le workflow**
```yaml
# ❌ Mauvais — résume le contenu, pas le déclencheur
description: >
  Ce skill guide la conception de SKILL.md en 4 étapes :
  frontmatter, routing modèle, tableau de dispatch, règles universelles.

# ✅ Bon — décrit quand invoquer
description: >
  Use when creating a new Claude skill or making a major update.
  Triggers: "créer un skill", "nouveau skill", "skill builder", "skill design".
```

**4. Mentionner les exclusions si le périmètre peut être confondu**
Évite les faux positifs coûteux. Si ton skill ressemble à un autre du même projet,
ajouter une ligne `NE PAS utiliser pour...`.

**5. Longueur cible : 40–80 mots**
En dessous : pas assez de mots-clés pour une bonne détection.
Au-dessus : le contexte est dilué, les premiers termes discriminants noyés.

---

## Checklist description

- [ ] Commence par "Use when" / "Utiliser quand" / "Déclencher quand"
- [ ] Contient une ligne `Triggers:` avec au moins 4 synonymes
- [ ] Ne décrit pas le contenu du skill, seulement *quand* l'utiliser
- [ ] Couvre les formulations françaises ET anglaises si le projet est bilingue
- [ ] Mentionne les exclusions si risque de confusion avec un autre skill
- [ ] Entre 40 et 80 mots

---

## Test de validation

Lire la description à voix haute et se demander :
> "Si je cherche [cas d'usage], est-ce que ce texte me ferait cliquer ?"

Si la réponse est non pour au moins 2 cas d'usage du skill → réécrire.
