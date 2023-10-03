# Create dns a record.
module "az_dns" {
  depends_on           = [module.az_appgw]                    # Wait for dependencies.
  source               = "./modules/az_dns"                   # The path to the module.
  record_name          = var.environment                      # The a record name.
  appgw_pip_ip_address = module.az_appgw.appgw_pip_ip_address # The appgw pip ip address.
}
