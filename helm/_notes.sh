#================================================================================================
# Dry Run
#================================================================================================
cd helm
helm upgrade titan ./titan --install --dry-run --namespace titan

#================================================================================================
# Install the Chart
#================================================================================================
helm upgrade titan ./titan --install --namespace titan --create-namespace --wait --atomic
https://prd.rhod3rz.com/analytics
https://prd.rhod3rz.com

#================================================================================================
# Interrogate
#================================================================================================
helm list -A
helm status titan -n titan
helm get manifest titan -n titan > titan.yaml

#================================================================================================
# Uninstall the Chart
#================================================================================================
helm uninstall titan -n titan

#================================================================================================
# Rollback
#================================================================================================
helm list -A
helm history titan -n titan
helm rollback titan -n titan 0 # Previous version.
helm rollback titan -n titan 1 # Specific version.
