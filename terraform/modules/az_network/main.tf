# Create a vnet.
resource "azurerm_virtual_network" "vn" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.vnet_name
  address_space       = [var.vnet]
  tags                = var.tags
}

# Create the subnets.
resource "azurerm_subnet" "subnet" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet } # For each loop (for_each needs a map; this { for } loop converts it.
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = [each.value.address_prefix]
}
