terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "demosastatetf"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
    k8s = {
      source  = "banzaicloud/k8s"
      version = "0.8.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.10.6"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.1.5"
    }
  }
  required_version = ">= 0.13"
}