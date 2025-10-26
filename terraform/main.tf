# Configure Azure Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "railway_rg" {
  name     = "railway-booking-dev-rg"
  location = "East US"
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "railwayacrdev"
  resource_group_name = azurerm_resource_group.railway_rg.name
  location            = azurerm_resource_group.railway_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}