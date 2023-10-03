# Create keyvault.
module "az_keyvault" {
  source              = "./modules/az_keyvault"                                          # The path to the module.
  location            = var.location                                                     # The location.
  resource_group_name = azurerm_resource_group.rg.name                                   # The resource group.
  law_id              = module.az_base.law_id                                            # The log analytics workspace id.
  keyvault_name       = "kv-${var.environment}-${var.application_code}-${var.unique_id}" # Keyvault name.
  tags                = local.tags                                                       # The tags.
}

# Create keyvault access policies.
resource "azurerm_key_vault_access_policy" "kvap_core" {
  depends_on              = [module.az_keyvault]
  for_each                = { for my_kv in var.keyvault_policies : my_kv.access_policy_name => my_kv }
  key_vault_id            = module.az_keyvault.keyvault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.value.object_id
  key_permissions         = try(each.value.key_permissions, [])
  secret_permissions      = try(each.value.secret_permissions, [])
  certificate_permissions = try(each.value.certificate_permissions, [])
}

# Create keyvault access policies.
resource "azurerm_key_vault_access_policy" "kvap_aks" {
  depends_on              = [module.az_keyvault]
  key_vault_id            = module.az_keyvault.keyvault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = module.az_aks.aks_uai_agentpool_object_id
  key_permissions         = ["Get"]
  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]
}
