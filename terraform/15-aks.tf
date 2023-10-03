# Create kubernetes cluster.
module "az_aks" {
  depends_on          = [module.az_base, module.az_network, module.az_appgw]              # Wait for dependencies.
  source              = "./modules/az_aks"                                                # The path to the module.
  location            = var.location                                                      # The location.
  resource_group_name = azurerm_resource_group.rg.name                                    # The resource group.
  law_id              = module.az_base.law_id                                             # The log analytics workspace id.
  aks_name            = "aks-${var.environment}-${var.application_code}-${var.unique_id}" # The AKS cluster name.
  subnet_aks          = module.az_network.subnet_ids.snet-aks                             # The AKS subnet id.
  appgw_id            = module.az_appgw.appgw_appgw_id                                    # The appgw id.
  tags                = local.tags                                                        # The tags.
}
