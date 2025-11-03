
resource "helm_release" "prometheus" {

  name       = "my-prometheus"

  namespace =  "default"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart      = "kube-prometheus-stack"
}

