# Install helm charts.
module "az_helm" {
  depends_on = [module.az_aks]     # Wait for dependencies.
  source     = "./modules/az_helm" # The path to the module.
}
