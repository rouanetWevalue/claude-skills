# Bash / Shell

---

## En-tête obligatoire

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `set -e` : sortie immédiate en cas d'erreur
- `set -u` : erreur si variable non définie
- `set -o pipefail` : un pipe échoué = script échoué

---

## Conventions de base

```bash
# Variables : majuscules pour les constantes, minuscules pour les locales
readonly CONFIG_FILE="/etc/app/config.yaml"
local tmp_dir

# Toujours citer les variables
echo "${VAR}"
cp "${src}" "${dst}"

# Pas de backticks — utiliser $()
result=$(command)
```

## Vérification des dépendances

```bash
# En début de script
for cmd in curl jq docker; do
  command -v "${cmd}" >/dev/null 2>&1 || {
    echo "ERROR: '${cmd}' est requis mais non installé." >&2
    exit 1
  }
done
```

## Fonctions

```bash
# Nommer clairement, documenter si non évident
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] <arg>
  -h  Affiche cette aide
  -v  Mode verbose
EOF
}

log_info()  { echo "[INFO]  $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }

# Retourner des codes d'erreur explicites
validate_input() {
  local input="$1"
  [[ -z "${input}" ]] && { log_error "Input vide"; return 1; }
  [[ "${input}" =~ ^[0-9]+$ ]] || { log_error "Input non numérique"; return 1; }
}
```

## Gestion des fichiers temporaires

```bash
# Nettoyer automatiquement
tmp=$(mktemp)
trap 'rm -f "${tmp}"' EXIT
```

## Arguments et options

```bash
# Parser avec getopts pour les scripts réutilisables
while getopts "hv:o:" opt; do
  case "${opt}" in
    h) usage; exit 0 ;;
    v) verbose="${OPTARG}" ;;
    o) output="${OPTARG}" ;;
    *) usage; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
```

## Tests (bats)

```bash
# test/validate_input.bats
@test "retourne une erreur si input vide" {
  run validate_input ""
  [ "$status" -eq 1 ]
}

@test "accepte un entier valide" {
  run validate_input "42"
  [ "$status" -eq 0 ]
}
```

## Notes

- Préférer `[[ ]]` à `[ ]` pour les conditions
- Préférer `printf` à `echo` pour les sorties formatées
- Scripts longs (>100 lignes) : considérer Python
- Toujours tester avec `shellcheck` avant de livrer
