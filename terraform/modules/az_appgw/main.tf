# ---------------------------------------------------------------- #
# ---------------------------------------------------------------- #

# Create public ip.
resource "azurerm_public_ip" "pip" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.appgw_pip
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Connect to log analytics.
resource "azurerm_monitor_diagnostic_setting" "mds_pip" {
  name                       = "diag-adf"
  target_resource_id         = azurerm_public_ip.pip.id
  log_analytics_workspace_id = var.law_id
  enabled_log {
    category_group = "audit"
  }
  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
  }
}

# ---------------------------------------------------------------- #
# ---------------------------------------------------------------- #

locals {
  backend_address_pool_name      = "be-dummy"
  frontend_port_name             = "fept-dummy"
  frontend_ip_configuration_name = "feic-dummy"
  http_setting_name              = "hs-example.dummy.com-http"
  listener_name                  = "ls-example.dummy.com-http"
  request_routing_rule_name      = "rr-example.dummy.com-http"
  redirect_configuration_name    = "rd-dummy"
}

# Create basic application gateway (all config is done via aks agic controller).
resource "azurerm_application_gateway" "ag" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.appgw_name
  enable_http2        = true

  sku {
    name     = "WAF_v2" # Standard_v2 or WAF_v2
    tier     = "WAF_v2" # Standard_v2 or WAF_v2
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.appgw_subnet
  }

  # --------------------- #
  # --- Shared Config --- #
  # --------------------- #
  # This creates the 'public' frontend; an alternative option is private. If created via the portal it is auto-named.
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  # ----------------- #
  # --- 80 Config --- #
  # ----------------- #
  # The routing rule that combines (1) the listener, (2) the backend pool and (3) the http settings.
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = "100"
  }

  # 1. The 'listener' config.
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  # 2. The 'backend pool' config.
  backend_address_pool {
    name = local.backend_address_pool_name
  }

  # 3. The 'http settings' config (aka how AGW will communicate with the backend pool e.g. 80 or 443 if E2E TLS is required).
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
  }

  # Ignore most changes as they will be managed via aks agic.
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      url_path_map,
      ssl_certificate,
      redirect_configuration,
      autoscale_configuration,
      tags
    ]
  }

  tags = var.tags

}

# Connect to log analytics.
resource "azurerm_monitor_diagnostic_setting" "mds_appgw" {
  name                       = "diag-appgw"
  target_resource_id         = azurerm_application_gateway.ag.id
  log_analytics_workspace_id = var.law_id
  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
  }
}

# ---------------------------------------------------------------- #
# ---------------------------------------------------------------- #
