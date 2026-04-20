# MCPs — Model Context Protocol Servers

Liste des MCP servers utilisés dans ce profil Claude, avec leur rôle et les skills qui en dépendent.

## Installation

```bash
./scripts/install-mcps.sh
```

Le script lit les fichiers `mcps/*.json` et les enregistre dans `~/.claude/settings.json`.
Redémarre Claude Code après installation pour activer les MCPs.

**Prérequis** : `jq` doit être installé (`winget install jqlang.jq` sur Windows).

## MCPs disponibles

| MCP | Commande | Utilisé par | Rôle |
|---|---|---|---|
| `playwright` | `npx @playwright/mcp@latest` | `extraction-linkedin` | Browser automation headless — extraction profil LinkedIn via URL |

## Ajouter un nouveau MCP

1. Créer `mcps/<nom>.json` avec la structure :
   ```json
   {
     "name": "nom-du-mcp",
     "description": "Ce que fait ce MCP",
     "server": {
       "command": "npx",
       "args": ["@package/mcp@latest"]
     },
     "usedBy": ["skill-qui-en-depend"],
     "requiredBy": "description du besoin"
   }
   ```
2. Relancer `./scripts/install-mcps.sh`
3. Mettre à jour ce README (tableau ci-dessus)
