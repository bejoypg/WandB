# terraform-azurerm-wandb

This README documents the steps followed to bring up the WandB platform in Azure infrastructure.

## Summary of changes
- Added/updated environment defaults in `terraform.tfvars`:
  - namespace = `bejoyp`
  - location = `westeurope`
  - node_pool_zones = `["3"]`
  - storage_account = `bejoysa`
  - subdomain / domain_name = `pg.bejoypg87`
  - overrides for AKS instance type and node counts:
    - kubernetes_instance_type = `Standard_E4s_v6`
    - kubernetes_min_node_per_az = `1`
    - kubernetes_max_node_per_az = `6`
  - other flags: `use_internal_queue = "true"`, `ssl = "false"`, `deletion_protection = false`

## Create providers.tf in repo root and wire providers to AKS outputs:

```hcl
terraform {
  required_providers {
    azurerm     = { source = "hashicorp/azurerm" }
    kubernetes  = { source = "hashicorp/kubernetes" }
    helm        = { source = "hashicorp/helm" }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.app_aks.kube_host
  token                  = module.app_aks.kube_admin_token
  cluster_ca_certificate = base64decode(module.app_aks.kube_ca)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = module.app_aks.kube_host
    token                  = module.app_aks.kube_admin_token
    cluster_ca_certificate = base64decode(module.app_aks.kube_ca)
    load_config_file       = false
  }
}
```

## Bring up the cluster and WandB platform by below.
1. Authenticate:
   - az login
   - Provisioned quotas required as required for the deployment.
2. Initialize & plan:

```bash
terraform init
terraform plan -out plan.tfplan
terraform show -json plan.tfplan > plan.json
terraform apply
```