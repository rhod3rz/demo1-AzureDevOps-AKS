# Create mysql server.
resource "azurerm_mysql_server" "mss" {
  location                          = var.location
  resource_group_name               = var.resource_group_name
  name                              = var.mysql_name
  administrator_login               = data.azurerm_key_vault_secret.kv-sql-username.value
  administrator_login_password      = data.azurerm_key_vault_secret.kv-sql-password.value
  sku_name                          = "B_Gen5_2"
  storage_mb                        = "5120"
  version                           = "5.7"
  auto_grow_enabled                 = true
  backup_retention_days             = "7"
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  ssl_minimal_tls_version_enforced  = "TLSEnforcementDisabled"
  tags                              = var.tags
}

# Create mysql firewall rule.
resource "azurerm_mysql_firewall_rule" "msfr-azure" {
  resource_group_name = var.resource_group_name
  name                = "allowAnyAzureIp"
  server_name         = azurerm_mysql_server.mss.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Create mysql firewall rule.
resource "azurerm_mysql_firewall_rule" "msfr-local" {
  resource_group_name = var.resource_group_name
  name                = "allowMyLocalIp"
  server_name         = azurerm_mysql_server.mss.name
  start_ip_address    = "86.10.95.19"
  end_ip_address      = "86.10.95.19"
}

# Connect to log analytics.
resource "azurerm_monitor_diagnostic_setting" "mds_mysql" {
  name                       = "diag-mysql"
  target_resource_id         = azurerm_mysql_server.mss.id
  log_analytics_workspace_id = var.law_id
  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
  }
}
