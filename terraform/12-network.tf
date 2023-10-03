# Create network.
module "az_network" {
  source              = "./modules/az_network"          # The path to the module.
  location            = var.location                    # The location.
  resource_group_name = azurerm_resource_group.rg.name  # The resource group.
  vnet_name           = "vnet-spoke-${var.environment}" # The vnet name.
  vnet                = var.vnet                        # The vnet cidr.
  subnets             = var.subnets                     # The list of subnet cidrs.
  tags                = local.tags                      # The tags.
}
