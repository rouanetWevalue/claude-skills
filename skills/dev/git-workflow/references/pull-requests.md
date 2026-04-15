# Pull Requests / Merge Requests — Conventions

## Règles de merge

- **Stratégie** : Squash & Merge uniquement
- **CI** : doit être en succès avant tout merge
- **Approbation** : minimum 1 review/validation humaine requise
- **Force push** : interdit sur une branche en cours de review

---

## Taille

Pas de limite stricte. Favoriser les PRs courtes et ciblées :
- Plus facile à reviewer, moins risqué en cas de revert
- Si la PR est importante, s'appuyer sur la règle SRP des commits (`references/commits.md`) pour structurer la review

---

## Process

1. **Self-review** obligatoire avant de demander une review externe — relire son diff comme si on était reviewer
2. La CI doit être verte avant de demander une review (et le rester jusqu'au merge)
3. Résoudre tous les commentaires avant de merger
4. Ne jamais merger sans CI verte et approbation

---

## Description — Structure suggérée

La structure est recommandée, non imposée. L'adapter au contexte.

```markdown
## Contexte
Pourquoi ce changement existe — problème résolu ou besoin couvert.

## Ce qui change
Résumé des modifications clés (pas un diff exhaustif).

## Comment tester
Étapes reproductibles pour valider le comportement attendu.

## Ticket
Lien vers le ticket associé (si applicable).
```
