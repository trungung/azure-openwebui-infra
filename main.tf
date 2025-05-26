provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

provider "random" {}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_id.suffix.hex}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_share" "share" {
  name               = var.file_share_name
  storage_account_id = azurerm_storage_account.sa.id
  quota              = 10
}

resource "azurerm_container_app_environment" "env" {
  name                = var.container_app_env_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_container_app_environment_storage" "storage" {
  name                         = "openwebui-storage"
  account_name                 = azurerm_storage_account.sa.name
  access_key                   = azurerm_storage_account.sa.primary_access_key
  container_app_environment_id = azurerm_container_app_environment.env.id
  share_name                   = azurerm_storage_share.share.name
  access_mode                  = "ReadWrite"
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "openwebui"
      image  = var.container_image
      cpu    = 1
      memory = "2Gi"

      volume_mounts {
        name = "openwebui-volume"
        path = "/app/backend/data"
      }
    }

    min_replicas = 1
    max_replicas = 1

    volume {
      name          = "openwebui-volume"
      storage_name  = azurerm_container_app_environment_storage.storage.name
      storage_type  = "AzureFile"
      mount_options = "nobrl"
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
