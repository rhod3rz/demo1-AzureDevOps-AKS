#================================================================================================
# Test 1
#================================================================================================

cd test\test1
kubectl delete namespace titan
kubectl apply -f .\0-namespace.yaml
kubectl apply -f .\1-nginx-80-pod.yaml
kubectl apply -f .\2-nginx-80-service.yaml
kubectl apply -f .\3-nginx-80-ingress.yaml
kubectl delete namespace titan

#================================================================================================
# Test 2
#================================================================================================
cd test\test2
kubectl delete namespace titan
kubectl apply -f .\0-namespace.yaml
kubectl apply -f .\1-csi-driver.yaml
kubectl apply -f .\2-nginx-80-pod.yaml
kubectl apply -f .\3-nginx-80-service.yaml
kubectl apply -f .\4-cluster-issuer.yaml
kubectl apply -f .\5-nginx-443-ingress-cert-manager.yaml
kubectl delete namespace titan
kubectl delete clusterissuer letsencrypt-issuer
