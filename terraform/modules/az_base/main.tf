# Create log analytics workspaces.
resource "azurerm_log_analytics_workspace" "law" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.law_name
  sku                 = "PerGB2018"
  tags                = var.tags
}

# Create log analytics solution for aks.
resource "azurerm_log_analytics_solution" "las" {
  location              = var.location
  resource_group_name   = var.resource_group_name
  solution_name         = "ContainerInsights"
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  tags                  = var.tags
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# Create application insights.
resource "azurerm_application_insights" "ai" {
  name                = var.appi_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = var.tags
}

# This resource sits here just to have it imported into the state; azure will auto-create it otherwise.
# If azure auto-creates it, then terraform destory will fail.
resource "azurerm_monitor_action_group" "mag" {
  name                = join("-", ["amag", var.appi_name])
  resource_group_name = var.resource_group_name
  short_name          = "amag" # used only for sms
}

# This resource sits here just to have it imported into the state; azure will auto-create it otherwise.
# If azure auto-creates it, then terraform destory will fail.
resource "azurerm_monitor_smart_detector_alert_rule" "msdar" {
  name                = "Failure Anomalies - ${var.appi_name}"
  resource_group_name = var.resource_group_name
  detector_type       = "FailureAnomaliesDetector"
  scope_resource_ids  = [azurerm_application_insights.ai.id]
  severity            = "Sev0"
  frequency           = "PT1M"
  action_group {
    ids = [azurerm_monitor_action_group.mag.id]
  }
}
