provider "azurerm" {
 subscription_id = "e627a6e5-6db0-497b-a1a9-5fdb1ae5116b"
 features {}
  }

provider "azapi" {
 subscription_id = "e627a6e5-6db0-497b-a1a9-5fdb1ae5116b"
  }

provider "kubernetes" {
   host                   = module.app_aks.cluster_host
   cluster_ca_certificate = base64decode(module.app_aks.cluster_ca_certificate)
   client_key             = base64decode(module.app_aks.cluster_client_key)
   client_certificate     = base64decode(module.app_aks.cluster_client_certificate)
  }

provider "helm" {
 kubernetes {
   host                   = module.app_aks.cluster_host
   cluster_ca_certificate = base64decode(module.app_aks.cluster_ca_certificate)
   client_key             = base64decode(module.app_aks.cluster_client_key)
   client_certificate     = base64decode(module.app_aks.cluster_client_certificate)
 }
  }