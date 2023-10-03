# Tweak 1
resource "azurerm_role_assignment" "contributor-to-aks-ingress-on-appgw-resource-group" {
  scope                = var.tw1_resource_group_appgw
  role_definition_name = "Contributor"
  principal_id         = var.tw1_uai_appgw
}

# Tweak 2
resource "azurerm_role_assignment" "acrpull-to-aks-agentpool-on-acr" {
  scope                = data.azurerm_container_registry.cr.id
  role_definition_name = "AcrPull"
  principal_id         = var.tw2_uai_agentpool
}

# Tweak 3
resource "azurerm_key_vault_access_policy" "kvap" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.tw3_uai_agentpool
  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get",
  ]
  certificate_permissions = [
    "Get",
  ]
}
