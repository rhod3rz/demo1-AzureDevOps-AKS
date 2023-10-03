# AGW
output "appgw_pip_ip_address" { value = module.az_appgw.appgw_pip_ip_address }
output "appgw_appgw_id" { value = module.az_appgw.appgw_appgw_id }

# AKS
output "aks_uai_agentpool_object_id" { value = module.az_aks.aks_uai_agentpool_object_id }
output "aks_uai_agentpool_client_id" { value = module.az_aks.aks_uai_agentpool_client_id }
output "aks_uai_appgw_object_id" { value = module.az_aks.aks_uai_appgw_object_id }

# BASE
output "base_law_id" { value = module.az_base.law_id }

# KEYVAULT
output "keyvault_keyvault_id" { value = module.az_keyvault.keyvault_id }
output "keyvault_keyvault_name" { value = module.az_keyvault.keyvault_name }

# MYSQL
output "mysql_mysql_name" { value = module.az_mysql.mysql_name }
output "mysql_mysql_fqdn" { value = module.az_mysql.mysql_fqdn }

# NETWORK
output "network_subnet_aks" { value = module.az_network.subnet_ids.snet-aks }
output "network_subnet_appgw" { value = module.az_network.subnet_ids.snet-appgw }
