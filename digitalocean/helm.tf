provider "kubernetes" {
  host                   = "${digitalocean_kubernetes_cluster.consul.endpoint}"
  token                  = "${digitalocean_kubernetes_cluster.consul.kube_config.0.token}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.consul.kube_config.0.cluster_ca_certificate)}"
}

# Create the tiller RBAC permissions
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata[0].name
    namespace = "kube-system"
  }
}

