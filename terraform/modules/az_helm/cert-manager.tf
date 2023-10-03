# Install cert-manager.
resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  version          = "1.12.3"
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  atomic           = true
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}
