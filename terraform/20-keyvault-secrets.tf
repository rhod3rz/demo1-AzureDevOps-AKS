#================================================================================================
# GET SOURCE KEYVAULT DETAILS
#================================================================================================
data "azurerm_key_vault" "kv_core" {
  name                = "kv-core-210713"
  resource_group_name = "rg-core-01"
}



#================================================================================================
# AKS UAI AGENTPOOL CLIENT_ID
# Required by the csi driver secret provider class yaml file.
#================================================================================================
resource "azurerm_key_vault_secret" "KV-UAI-AKS-AGENTPOOL" {
  depends_on   = [module.az_keyvault, resource.azurerm_key_vault_access_policy.kvap_core]
  name         = "KV-UAI-AKS-AGENTPOOL"
  value        = module.az_aks.aks_uai_agentpool_client_id
  key_vault_id = module.az_keyvault.keyvault_id
}



#================================================================================================
# APPLICATION INSIGHTS
# Required by the pods to set an environment variable so application insights works.
#================================================================================================
resource "azurerm_key_vault_secret" "KV-APPLICATIONINSIGHTS-CONNECTION-STRING" {
  depends_on   = [module.az_keyvault, resource.azurerm_key_vault_access_policy.kvap_core]
  name         = "KV-APPLICATIONINSIGHTS-CONNECTION-STRING"
  value        = module.az_base.ai_connection_string
  key_vault_id = module.az_keyvault.keyvault_id
}



#================================================================================================
# MYSQL
# Required by the pods to connect to MySQL.
#================================================================================================
data "azurerm_key_vault_secret" "KV-SQL-ADMIN-PASSWORD" {
  key_vault_id = data.azurerm_key_vault.kv_core.id
  name         = "KV-SQL-ADMIN-PASSWORD"
}
data "azurerm_key_vault_secret" "KV-SQL-ADMIN-USERNAME" {
  key_vault_id = data.azurerm_key_vault.kv_core.id
  name         = "KV-SQL-ADMIN-USERNAME"
}
resource "azurerm_key_vault_secret" "KV-SQL-ADMIN-PASSWORD" {
  depends_on   = [module.az_keyvault, resource.azurerm_key_vault_access_policy.kvap_core]
  name         = "KV-SQL-ADMIN-PASSWORD"
  value        = data.azurerm_key_vault_secret.KV-SQL-ADMIN-PASSWORD.value
  key_vault_id = module.az_keyvault.keyvault_id
}
resource "azurerm_key_vault_secret" "KV-SQL-ADMIN-USERNAME" {
  depends_on   = [module.az_keyvault, resource.azurerm_key_vault_access_policy.kvap_core]
  name         = "KV-SQL-ADMIN-USERNAME"
  value        = data.azurerm_key_vault_secret.KV-SQL-ADMIN-USERNAME.value
  key_vault_id = module.az_keyvault.keyvault_id
}
