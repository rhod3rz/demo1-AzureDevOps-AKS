# Create kubernetes cluster tweaks.
module "az_aks_tweaks" {

  depends_on = [module.az_aks]           # Wait for dependencies.
  source     = "./modules/az_aks_tweaks" # The path to the module.

  # Tweak 1 - Resource group (IAM) - set 'contributor' role assignment for the 'ingressapplicationgateway' uai on the appgw vnet & resource group; otherwise it can't manage ingress.
  # The following error is seen in ingress pod logs if not set 'E0722 13:28:17.457834 1 client.go:170] Code="ErrorApplicationGatewayForbidden"'.
  # If you monitor the ingress pod logs; this can take up to 60 mins to kick in; sometimes you need to delete the ingress pod and let it recreate.
  tw1_resource_group_appgw = azurerm_resource_group.rg.id          # The resource group id to add IAM permissions for uai 'ingressapplicationgateway'.
  tw1_uai_appgw            = module.az_aks.aks_uai_appgw_object_id # The auto created 'ingressapplicationgateway' uai account object / principal id.

  # Tweak 2 - Resource group (IAM) - set 'acrpull' role assignment for the 'aksagentpool' uai on the acr; otherwise it can't pull images.
  tw2_uai_agentpool = module.az_aks.aks_uai_agentpool_object_id # The auto created 'agentpool' uai account object / principal id.

  # Tweak 3 - Csi-driver - add 'aksagentpool' uai to access policies in key vault.
  tw3_uai_agentpool = module.az_aks.aks_uai_agentpool_object_id # The auto created 'agentpool' uai account object / principal id.

}
