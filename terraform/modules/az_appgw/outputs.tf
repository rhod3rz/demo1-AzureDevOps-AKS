output "appgw_pip_ip_address" { value = azurerm_public_ip.pip.ip_address }
output "appgw_appgw_id" { value = azurerm_application_gateway.ag.id }
