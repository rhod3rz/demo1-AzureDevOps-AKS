# Get the key vault rg.
data "azurerm_key_vault" "kv" {
  name                = "kv-core-210713"
  resource_group_name = "rg-core-01"
}

# Get sql admin username.
data "azurerm_key_vault_secret" "kv-sql-username" {
  name         = "KV-SQL-ADMIN-USERNAME"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Get sql admin password.
data "azurerm_key_vault_secret" "kv-sql-password" {
  name         = "KV-SQL-ADMIN-PASSWORD"
  key_vault_id = data.azurerm_key_vault.kv.id
}
