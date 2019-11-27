resource "kubernetes_deployment" "web" {
  depends_on = [helm_release.consul]

  metadata {
    name = "web"
    labels = {
      app = "web"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "web"
      }
    }

    template {
      metadata {
        labels = {
          app     = "web"
          version = "v0.1"
        }

        annotations = {
          "consul.hashicorp.com/connect-inject"            = "true"
          "consul.hashicorp.com/connect-service-upstreams" = "payment:9091"
          "consul.hashicorp.com/connect-service-name"      = "web"
        }
      }

      spec {
        container {
          image = "nicholasjackson/fake-service:v0.7.8"
          name  = "web"

          port {
            name           = "http"
            container_port = 9090
          }

          env {
            name  = "LISTEN_ADDR"
            value = "0.0.0.0:9090"
          }

          env {
            name  = "UPSTREAM_URIS"
            value = "http://localhost:9091"
          }

          env {
            name  = "MESSAGE"
            value = "Welcome to the service mesh superstore!"
          }

          env {
            name  = "NAME"
            value = "web"
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "0.1"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web_service" {
  metadata {
    name = "web-lb"
  }

  spec {
    selector = {
      app = "web"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 9090
    }

    type = "LoadBalancer"
  }
}
