# Azure Container Instance for Railway App
resource "azurerm_container_group" "railway_app" {
  name                = "railway-app-dev"
  location            = azurerm_resource_group.railway_rg.location
  resource_group_name = azurerm_resource_group.railway_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "railwayappdev"
  os_type             = "Linux"
  restart_policy      = "Always"

  container {
    name   = "railway-booking-app"
    image  = "railwayacrdev.azurecr.io/railway-booking-system:latest"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      "NODE_ENV" = "production"
      "PORT"     = "3000"
    }
  }

  image_registry_credential {
    server   = "railwayacrdev.azurecr.io"
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  tags = {
    Environment = "Development"
    Project     = "Railway Booking"
  }

  depends_on = [azurerm_container_registry.acr]
}

output "application_url" {
  value = "http://${azurerm_container_group.railway_app.fqdn}:3000"
}

output "ip_address" {
  value = azurerm_container_group.railway_app.ip_address
}