#================================================================================================
# Provider Configuration
#================================================================================================

terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = var.environment == "prd" ? true : false
    }
  }
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  subscription_id = var.subscription_id
  # client_secret = Use $env:ARM_CLIENT_SECRET or ARM_CLIENT_SECRET if bash
}

provider "helm" {
  kubernetes {
    host                   = module.az_aks.aks_config.0.host
    client_certificate     = base64decode(module.az_aks.aks_config.0.client_certificate)
    client_key             = base64decode(module.az_aks.aks_config.0.client_key)
    cluster_ca_certificate = base64decode(module.az_aks.aks_config.0.cluster_ca_certificate)
  }
}

#================================================================================================
# Backend Configuration
#================================================================================================

terraform {
  backend "azurerm" {
    storage_account_name = "sadlterraformstate210713" # UPDATE HERE.
    container_name       = "demo19"                   # UPDATE HERE.
    # key                = Specify via t init -backend-config="key=env-feature.tfstate"
    # access_key         = Use $env:ARM_ACCESS_KEY or ARM_ACCESS_KEY if bash
  }
}
