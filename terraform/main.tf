terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Specify the version as needed
    }
  }

  required_version = ">= 1.0"  # Specify the required Terraform version
}

provider "azurerm" {
  features {}  # Required, but can be empty
}

resource "azurerm_resource_group" "rg" {
  name     = "apache-k8s-rg"
  location = "Poland Central"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "apache-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "apacheweb"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "apacheacr2011003"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}
