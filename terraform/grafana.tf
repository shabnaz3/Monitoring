
resource "helm_release" "grafana" {

  name       = "my-grafana"

  namespace =   "default"

  repository = "https://grafana.github.io/helm-charts"

  chart      = "grafana"

  
}


