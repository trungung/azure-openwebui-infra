output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "file_share_url" {
  value = "https://${azurerm_storage_account.sa.name}.file.core.windows.net/${azurerm_storage_share.share.name}"
}

output "container_app_url" {
  value = azurerm_container_app.app.latest_revision_fqdn
}
