# Create access gateway.
module "az_appgw" {
  depends_on          = [module.az_base, module.az_network]                                 # Wait for dependencies.
  source              = "./modules/az_appgw"                                                # The path to the module.
  location            = var.location                                                        # The location.
  resource_group_name = azurerm_resource_group.rg.name                                      # The resource group.
  law_id              = module.az_base.law_id                                               # The log analytics workspace id.
  appgw_pip           = "pip-${var.environment}-${var.application_code}-${var.unique_id}"   # The appgw pip name.
  appgw_name          = "appgw-${var.environment}-${var.application_code}-${var.unique_id}" # The appgw name.
  appgw_subnet        = module.az_network.subnet_ids.snet-appgw                             # The appgw subnet id.
  tags                = local.tags                                                          # The tags.
}
