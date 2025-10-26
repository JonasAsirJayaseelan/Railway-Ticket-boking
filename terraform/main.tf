# Configure Azure Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "railway_rg" {
  name     = "railway-booking-rg"
  location = "East US"
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "railwayacr${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.railway_rg.name
  location            = azurerm_resource_group.railway_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "railway-aks"
  location            = azurerm_resource_group.railway_rg.location
  resource_group_name = azurerm_resource_group.railway_rg.name
  dns_prefix          = "railwayaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Random integer for unique naming
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Output values
output "resource_group_name" {
  value = azurerm_resource_group.railway_rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}