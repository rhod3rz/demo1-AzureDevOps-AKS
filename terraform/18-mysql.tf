# Create mysql server.
module "az_mysql" {
  source              = "./modules/az_mysql"                                                # The path to the module.
  location            = var.location                                                        # The location.
  resource_group_name = azurerm_resource_group.rg.name                                      # The resource group.
  law_id              = module.az_base.law_id                                               # The log analytics workspace id.
  mysql_name          = "mysql-${var.environment}-${var.application_code}-${var.unique_id}" # MySQL server name.
  tags                = local.tags                                                          # The tags.
}
