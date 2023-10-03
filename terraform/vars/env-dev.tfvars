#================================================================================================
# Environment Vars
#================================================================================================
environment     = "dev"
subscription_id = "2bc7b65e-18d6-42ae-afb2-e66d50be6b05"



#================================================================================================
# Networks
#================================================================================================
vnet = "10.11.0.0/16"
subnets = [
  {
    name           = "snet-aks"
    address_prefix = "10.11.1.0/24"
  },
  {
    name           = "snet-appgw"
    address_prefix = "10.11.2.0/24"
  }
]