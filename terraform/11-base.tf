# Create resource group.
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = lower("rg-${var.environment}-${var.application_code}-${var.unique_id}")
  tags     = local.tags
}

# Create pre-requisites (log analytics workspace, container insights solution & application insights).
module "az_base" {
  source              = "./modules/az_base"                                                # The path to the module.
  location            = var.location                                                       # The location.
  resource_group_name = azurerm_resource_group.rg.name                                     # The resource group.
  law_name            = "law-${var.environment}-${var.application_code}-${var.unique_id}"  # The log analytics workspace name.
  appi_name           = "appi-${var.environment}-${var.application_code}-${var.unique_id}" # Application insights name.
  tags                = local.tags                                                         # The tags.
}
