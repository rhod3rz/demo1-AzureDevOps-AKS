#================================================================================================
# Titan
#================================================================================================

cd test\titan
kubectl delete namespace titan
kubectl apply -f .\0-namespace.yaml
kubectl apply -f .\1-csi-driver.yaml
kubectl apply -f .\2-cluster-issuer.yaml
kubectl apply -f .\3-votinganalytics.yaml
kubectl apply -f .\4-votingapp.yaml
kubectl delete namespace titan
kubectl delete clusterissuer letsencrypt-issuer

https://prd.rhod3rz.com/analytics
https://prd.rhod3rz.com
