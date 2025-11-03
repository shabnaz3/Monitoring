provider "kubernetes" {
  # Configuration options
    config_path = "~/.kube/config"

}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "kubernetes_all_namespaces" "allns" {}

output "all-ns" {
  value = data.kubernetes_all_namespaces.allns.namespaces
}


# If you need to install dashbboard then resource helm_release is applicable

# resource "helm_release" "my-kubernetes-dashboard" {

#   name = "my-kubernetes-dashboard"
#   repository = "https://kubernetes.github.io/dashboard/"
#   chart      = "kubernetes-dashboard"
#   namespace  = "kube-system"
# }

# resource "kubernetes_service_account_v1" "example" {
#    metadata {
#      name = "admin-user"
#      namespace = "kube-system"
#     }
# }

# resource "kubernetes_secret" "example" {
#    metadata {
#      name = "dashboard-token"
#      namespace = "kube-system"
#      annotations = {
#        "kubernetes.io/service-account.name" = "admin-user"
#      }
#     }

#    type                           = "kubernetes.io/service-account-token"

#     depends_on = [
#      kubernetes_service_account_v1.example ,
#    ]
# }

# resource "kubernetes_cluster_role_binding_v1" "example" {
#    metadata {
#      name = "terraform-cluster"
#    }
#    role_ref {
#      api_group = "rbac.authorization.k8s.io"
#      kind      = "ClusterRole"
#      name      = "cluster-admin"
#    }
#    subject {
#      kind      = "ServiceAccount"
#      name      = "admin-user"
#      namespace = "kube-system"
#    }
#    depends_on = [
#      kubernetes_service_account_v1.example
#    ]
# }


# # resource "null_resource" "port_forward_dashboard" {
# #   provisioner "local-exec" {
# #     command = "kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10443:443"
# #   }
# # }

# output "tokenValue" {
#    value = nonsensitive(kubernetes_secret.example.data.token)
#  }
# output "kubernetes_dashboard_url" {
#   value = "https://localhost:10443/"
# }



