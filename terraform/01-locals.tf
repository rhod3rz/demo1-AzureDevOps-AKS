#================================================================================================
# Locals
#================================================================================================
locals {
  tags = merge({
    "3-ApplicationCode" = var.application_code
    "4-Environment"     = var.environment
  }, var.tags)
}
