resource "kubernetes_deployment" "currency" {
  depends_on = [helm_release.consul]

  metadata {
    name = "currency"
    labels = {
      app = "currency"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "currency"
      }
    }

    template {
      metadata {
        labels = {
          app     = "currency"
          version = "v0.1"
        }

        annotations = {
          "consul.hashicorp.com/connect-inject"       = "true"
          "consul.hashicorp.com/connect-service-name" = "currency"
        }
      }

      spec {
        container {
          image = "nicholasjackson/fake-service:v0.7.8"
          name  = "currency"

          port {
            name           = "http"
            container_port = 9090
          }

          env {
            name  = "LISTEN_ADDR"
            value = "0.0.0.0:9090"
          }

          env {
            name  = "MESSAGE"
            value = "rate 1USD to 3GBP"
          }

          env {
            name  = "NAME"
            value = "Currency"
          }

          env {
            name = "TRACING_DATADOG"
            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }

          env {
            name = "DD_API_KEY"
            value_from {
              secret_key_ref {
                name = "datadog-secret"
                key  = "api-key"
              }
            }
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

          liveness_probe {
            http_get {
              path = "/health"
              port = 9090
            }

            initial_delay_seconds = 1
            period_seconds        = 2
          }
        }
      }
    }
  }
}
