resource "kubernetes_deployment" "result" {
  metadata {
    name = "result"
    labels = {
      test = "result"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "result"
      }
    }

    template {
      metadata {
        labels = {
          test = "result"
        }
      }

      spec {
        container {
          image = "dockersamples/examplevotingapp_result"
          name  = "result"

          resources {
            
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

          }
        }
      }
    }
  }
}

resource "kubernetes_service" "result" {
  metadata {
    name = "result"
  }
  spec {
    selector = {
      app = "result"
    }

    port {
      name = "result-service"
      port        = 5001
      target_port = 80
      node_port   = 31008
    }

    type = "NodePort"
  }
}

resource "kubernetes_pod" "example" {
  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    container {
      image = "dockersamples/examplevotingapp_result"
      name  = "result"
    }
  }
}

resource "null_resource" "port_forward_dashboard" {
     provisioner "local-exec" {
     command = "kubectl port-forward -n default service/result 31008:31008 --address=0.0.0.0 &"
  }
}