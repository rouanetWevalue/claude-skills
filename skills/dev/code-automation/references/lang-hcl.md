# HCL / Terraform

---

## Structure de module

```
module/
├── main.tf           ← ressources principales
├── variables.tf      ← toutes les variables d'entrée
├── outputs.tf        ← toutes les sorties
├── versions.tf       ← contraintes provider et terraform
└── README.md         ← description, inputs, outputs
```

Pour un projet racine :
```
infra/
├── modules/          ← modules réutilisables
│   ├── network/
│   └── compute/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
└── shared/           ← ressources partagées
```

---

## Conventions

### Variables — toujours typées et décrites

```hcl
variable "instance_count" {
  description = "Nombre d'instances à créer"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "instance_count doit être > 0."
  }
}
```

### Locals — pour les expressions complexes

```hcl
locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  name_prefix = "${var.project_name}-${var.environment}"
}
```

### Outputs — documentés

```hcl
output "bucket_name" {
  description = "Nom du bucket S3 créé"
  value       = aws_s3_bucket.main.bucket
}

output "db_endpoint" {
  description = "Endpoint de la base de données"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}
```

### Versions — toujours fixées

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## Naming conventions

```
{project}-{env}-{resource_type}-{name}
ex: myapp-prod-sg-api
    myapp-staging-rds-users
```

---

## Bonnes pratiques

- **State remote** : toujours, jamais de state local en équipe
- **Workspaces** : utiliser pour les environnements ou préférer des dossiers séparés
- **Secrets** : variables marquées `sensitive = true`, jamais en dur
- **`depends_on`** : utiliser seulement si la dépendance implicite ne suffit pas
- **`count` vs `for_each`** : préférer `for_each` (moins fragile aux réordonnances)
- **`lifecycle`** : documenter pourquoi si `prevent_destroy` ou `ignore_changes`

---

## Tests

```bash
# Validation syntaxique
terraform fmt -check
terraform validate

# Tests d'intégration (Terratest / tftest)
# Tester dans un environnement éphémère, jamais en prod
```
