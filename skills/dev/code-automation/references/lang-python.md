# Python

---

## Conventions de base

- **Style** : PEP 8, formaté avec `black` ou `ruff`
- **Imports** : stdlib → third-party → local, séparés par une ligne vide
- **Type hints** : obligatoires sur les fonctions publiques
- **Docstrings** : modules, classes, fonctions publiques

```python
"""Module de traitement des configurations."""

import os
from pathlib import Path

import yaml  # third-party

from myapp.utils import logger  # local


def load_config(path: Path) -> dict[str, str]:
    """Charge et valide un fichier de configuration YAML.

    Args:
        path: Chemin vers le fichier de configuration.

    Returns:
        Dictionnaire de configuration validé.

    Raises:
        FileNotFoundError: Si le fichier n'existe pas.
        ValueError: Si la configuration est invalide.
    """
    if not path.exists():
        raise FileNotFoundError(f"Config not found: {path}")

    with path.open() as f:
        config = yaml.safe_load(f)

    return _validate_config(config)
```

---

## Gestion des erreurs

```python
# Exceptions spécifiques, pas Exception générique
class ConfigError(ValueError):
    """Erreur de configuration de l'application."""

# Context managers pour les ressources
with open(path) as f:
    data = f.read()

# Ne pas avaler les exceptions silencieusement
try:
    result = risky_operation()
except SpecificError as e:
    logger.error("Opération échouée: %s", e)
    raise  # ou raise AppError(...) from e
```

---

## Structure de projet

```
src/
├── myapp/
│   ├── __init__.py
│   ├── config.py       ← chargement config
│   ├── models.py       ← dataclasses / pydantic
│   ├── services/       ← logique métier
│   └── utils/          ← fonctions utilitaires
tests/
├── unit/
└── integration/
pyproject.toml
```

---

## Configuration et environnement

```python
# Utiliser pydantic-settings pour la config
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    api_key: str
    debug: bool = False

    class Config:
        env_file = ".env"

settings = Settings()  # lève une erreur si DATABASE_URL absent
```

---

## Tests (pytest)

```python
# tests/unit/test_config.py
import pytest
from pathlib import Path
from myapp.config import load_config, ConfigError

def test_load_config_valid(tmp_path):
    # Arrange
    config_file = tmp_path / "config.yaml"
    config_file.write_text("key: value\n")
    # Act
    result = load_config(config_file)
    # Assert
    assert result["key"] == "value"

def test_load_config_missing_file():
    with pytest.raises(FileNotFoundError):
        load_config(Path("/nonexistent/path.yaml"))
```

---

## Notes

- **Packaging** : `pyproject.toml` (pas `setup.py`)
- **Virtualenv** : `uv` ou `venv` — ne jamais installer en global
- **Async** : `asyncio` + `async/await` pour les I/O — `httpx` plutôt que `requests` en async
- **Scripts CLI** : `typer` ou `click` pour les interfaces en ligne de commande
- **Linting** : `ruff` couvre flake8 + isort + plus
