######################
# CREATE DNS RECORDS #
######################
# ---------------------------------------------------------------- #
# ---------------------------------------------------------------- #
# Create a record.
resource "azurerm_dns_a_record" "dar" {
  name                = var.record_name
  zone_name           = data.azurerm_dns_zone.dz.name
  resource_group_name = data.azurerm_dns_zone.dz.resource_group_name
  ttl                 = 300
  records             = ["${var.appgw_pip_ip_address}"]
}
# ---------------------------------------------------------------- #
# ---------------------------------------------------------------- #
