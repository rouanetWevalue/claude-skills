# Config — Initialiser et modifier .claude/todo-config.md

## Initialisation

Si `.claude/todo-config.md` n'existe pas dans le projet cible :
1. Créer le dossier `.claude/` si nécessaire
2. Créer le fichier avec le template par défaut ci-dessous
3. Confirmer avant d'écrire (sauf `auto_confirm: true` — ce qui ne peut pas encore être lu)

## Template par défaut

```markdown
# TODO Config

## Comportement général
auto_confirm: false           # skip confirmation avant écriture
session_start_summary: true   # résumé TODOs au démarrage de session

## Archivage
auto_archive: true            # archiver automatiquement les sections [x]

## Découpage
split_threshold: 200          # lignes avant proposition de découpage
auto_split: false             # découpage automatique sans proposition
disable_split_proposal: false # ne jamais proposer le découpage

## Triage
triage_triggers: []           # événements custom déclenchant un triage
                              # ex: ["nouvelle app", "incident prod"]

## Format (overrides du format wevalue-ai-lab)
todo_file: TODO.md
done_file: DONE.md
todo_dir: todo/
priorities: [P0, P1, P2, P3]
status_open: "[ ]"
status_inprogress: "[~]"
status_done: "[x]"
```

## Modification

1. Lire la config existante
2. Appliquer les changements demandés
3. Afficher le diff avant d'écrire :
   `clé: ancienne_valeur → nouvelle_valeur`
4. Confirmer avant d'écrire

## Valeurs par défaut (si config absente)

En l'absence de `.claude/todo-config.md`, toutes les opérations utilisent
les valeurs du template ci-dessus comme référence implicite.
