# Required for helm provider config.
# Could be kube_config or kube_admin_config; check tfstate file.
output "aks_config" { value = azurerm_kubernetes_cluster.kc.kube_admin_config }

# Required to set access policy on key vault for agentpool uai.
output "aks_uai_agentpool_object_id" { value = azurerm_kubernetes_cluster.kc.kubelet_identity[0].object_id }

# Required when setting up the csi driver secret provider class yaml file.
output "aks_uai_agentpool_client_id" { value = azurerm_kubernetes_cluster.kc.kubelet_identity[0].client_id }

# Required to set IAM role on appgw subnet for appgw uai.
output "aks_uai_appgw_object_id" { value = azurerm_kubernetes_cluster.kc.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id }
