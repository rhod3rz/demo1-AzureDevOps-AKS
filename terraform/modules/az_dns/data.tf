# Get azure dns zone.
data "azurerm_dns_zone" "dz" {
  name                = "rhod3rz.com"
  resource_group_name = "rg-core-01"
}
