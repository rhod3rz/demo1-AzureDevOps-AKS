# Create the aks cluster.
resource "azurerm_kubernetes_cluster" "kc" {
  location            = var.location
  resource_group_name = var.resource_group_name
  node_resource_group = "${var.resource_group_name}-nrg"
  name                = var.aks_name
  dns_prefix          = "${var.aks_name}-dns"
  sku_tier            = "Free"

  # Set the default node pool config.
  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    min_count           = "1"
    max_count           = "3"
    os_sku              = "Ubuntu"
    vm_size             = "Standard_B2s"
    max_pods            = "30"
    type                = "VirtualMachineScaleSets"
    zones               = ["1", "2", "3"]
    vnet_subnet_id      = var.subnet_aks # Nodes and pods will receive ip's from here.
  }

  # Set the identity profile.
  identity {
    type = "SystemAssigned"
  }

  # Enable aad integration and rbac.
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = ["a11b9012-e930-4801-bb3a-1a46e42b830a"]
    azure_rbac_enabled     = true
  }

  # Set the network profile.
  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.0.0/16" # Internal ip range used by cluster services.
    dns_service_ip = "10.0.0.10"
  }

  # Install application gateway.
  # Note: you MUST add a tweak to give the auto-created ingress uai the contributor iam role on the subnet or vnet; see tweak 1.
  # Note: it's normal for the pod/ingress-appgw-deployment to restart / crashloopbackoff whilst it's deploying agic.
  # Note: it can take ~15-20 mins for the appgw to install; monitor pod/ingress-appgw-deployment logs for errors and progress.
  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

  # Install log analytics agent.
  oms_agent {
    log_analytics_workspace_id = var.law_id
  }

  # Install csi driver.
  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count, # Ignore due to auto-scaling.
    ]
  }

  tags = var.tags

}
