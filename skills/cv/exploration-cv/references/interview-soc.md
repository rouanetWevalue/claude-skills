# Protocole d'interview Socratique pour l'enrichissement de profil

## Principe

L'interview Socratique ne complète pas les champs manquants par inférence — elle pose des questions ciblées pour faire émerger des informations que le candidat n'a pas formulées spontanément. Chaque question vise un champ précis du schéma normalisé.

---

## Quand creuser : signaux d'alarme

### Verbes vagues (→ demander "quoi exactement ?")
- "participé à", "contribué à", "impliqué dans"
- "aidé à", "soutenu", "supporté"
- "travaillé sur", "intervenu sur"
- "géré" sans objet ni périmètre

### Absence de métriques (→ demander "quel résultat ?")
- Réalisation sans chiffre, sans comparatif, sans avant/après
- Description d'une tâche sans mention de l'impact
- "amélioration de la performance" sans précision

### Compétences implicites (→ demander "avec quels outils ?")
- Poste qui implique des compétences non listées (ex : chef de projet → gestion de conflits, planification, budget)
- Expérience longue sans certifications associées
- Secteur réglementé sans mention des normes maîtrisées

### Descriptions trop courtes (→ demander "quel contexte ?")
- `description` < 2 lignes pour un poste > 1 an
- `realisations` vide ou à `null` pour une expérience senior
- `resume` générique sans différenciateurs

---

## Questions-types par champ du schéma

### `experiences[].realisations`
- "Sur ce projet, quel était l'état initial avant votre intervention ?"
- "Quel indicateur a évolué grâce à votre action ?"
- "Combien de personnes, de budgets ou de systèmes cela concernait-il ?"
- "En combien de temps ? Quel était l'objectif initial ?"

### `experiences[].description`
- "Quelle était votre mission principale, en une phrase ?"
- "De qui dépendiez-vous ? Qui supervisait votre travail ?"
- "Aviez-vous des responsabilités transverses (recrutement, budget, formation) ?"

### `competences[]`
- "Cette compétence, vous l'utilisez en autonomie ou en équipe ?"
- "Avez-vous formé d'autres personnes sur ce sujet ?"
- "Depuis combien d'années l'utilisez-vous en contexte professionnel ?"

### `certifications[]`
- "Avez-vous passé des certifications liées à cette technologie ou méthode ?"
- "Des formations certifiantes en cours ou prévues ?"

### `resume`
- "En 2 phrases, quelle est votre proposition de valeur différenciante ?"
- "Quel type de problèmes résolvez-vous mieux que vos pairs ?"

---

## Règles de conduite de l'interview

1. **Une question à la fois** — ne pas enchaîner plusieurs relances dans le même message
2. **Reformuler avant de creuser** — confirmer la compréhension avant de demander plus de détails
3. **Signaler les lacunes clairement** — liste les champs à enrichir après chaque échange
4. **Ne jamais inventer** — si la réponse ne vient pas, laisser le champ à `null` et le noter
5. **Clôturer l'enrichissement** — après 3 échanges sans nouvelle information, proposer de passer à la reformulation CAR

---

## Format de sortie intermédiaire

Après chaque échange, afficher :

```
Champs enrichis : [liste]
Champs encore à null : [liste]
Prochaine question : [question]
```
