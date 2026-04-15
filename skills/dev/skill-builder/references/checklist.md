# Checklist qualité — validation pré-PR

Exécuter cette checklist avant d'ouvrir une PR pour un skill nouveau ou mis à jour.

---

## 1. Structure

- [ ] `SKILL.md` présent avec frontmatter YAML (`name:`, `description:`)
- [ ] `SKILL.md` < 80 lignes (hors frontmatter) — sinon logique métier à extraire
- [ ] Dossier dans la bonne catégorie (`skills/dev/`, `skills/content/`, `skills/gestion/`)
- [ ] Chaque fichier `references/*.md` ≤ 150 lignes (CI vérifie)
- [ ] Un seul concept par fichier `references/`
- [ ] Chaque référence listée dans le tableau de routing de SKILL.md

## 2. Contenu

- [ ] Description YAML passe la checklist de `references/description-cso.md`
- [ ] Tableau de routing : contextes formulés comme intentions observables
- [ ] Chaque ligne du routing pointe vers un fichier qui existe
- [ ] Modèle justifié pour chaque phase (pas "Sonnet" par défaut sans raison)
- [ ] Règle universelle présente (confirmation avant écriture, ou équivalent)
- [ ] Tout le contenu rédigé en français (convention projet)

## 3. Qualité

- [ ] Aucune logique métier dans SKILL.md (tout dans references/)
- [ ] Aucun doublon de contenu entre les références
- [ ] Exemples contrastés dans les références (mauvais → bon)
- [ ] Edge cases nommés explicitement dans au moins une référence
- [ ] Audit Step 0 réalisé et résultats documentés (création ou mise à jour majeure)

---

## Table anti-rationalisation

Pensées qui signalent qu'on est en train de contourner une règle :

| Pensée | Réalité |
|---|---|
| "C'est un petit skill, pas besoin d'auditer" | L'audit prend 10 min. L'oublier coûte de réécrire. |
| "La description est assez claire" | La description est pour le moteur, pas pour toi. Appliquer CSO. |
| "Je mettrai les examples plus tard" | Sans examples, le skill sera mal appliqué dès la première utilisation. |
| "150 lignes c'est une limite arbitraire" | C'est la limite de lisibilité + règle CI. Scinder est toujours possible. |
| "Je n'ai pas besoin d'une référence séparée pour ça" | Si le contenu fait > 20 lignes dans SKILL.md, c'est une référence. |
| "Sonnet pour tout, c'est plus simple" | Haiku pour les tâches mécaniques = moins de tokens, même résultat. |

---

## Critères "done"

Un skill est prêt pour la PR quand :

1. Toutes les cases de la checklist structure et contenu sont cochées
2. L'utilisateur a validé la description et le routing
3. Les edge cases couverts ont été confrontés aux résultats de l'audit Step 0
4. CI verte localement (`wc -l` sur chaque references/*.md)
