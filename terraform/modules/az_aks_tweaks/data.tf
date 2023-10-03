# Tweak 2
# Get the acr details.
data "azurerm_container_registry" "cr" {
  name                = "acrdlnteudemoapps210713"
  resource_group_name = "rg-core-01"
}

# Tweak 3
# Get the key vault details.
data "azurerm_key_vault" "kv" {
  name                = "kv-core-210713"
  resource_group_name = "rg-core-01"
}
# Get the current client config.
data "azurerm_client_config" "current" {}
