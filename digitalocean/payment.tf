resource "kubernetes_deployment" "payment" {
  depends_on = [helm_release.consul]

  metadata {
    name = "payment"
    labels = {
      app = "payment"
    }
  }

  spec {
    replicas = 10

    selector {
      match_labels = {
        app = "payment"
      }
    }

    template {
      metadata {
        labels = {
          app     = "payment"
          version = "v0.1"
        }

        annotations = {
          "consul.hashicorp.com/connect-inject"            = "true"
          "consul.hashicorp.com/connect-service-upstreams" = "payment-gateway:9091"
          "consul.hashicorp.com/connect-service-name"      = "payment"
        }
      }

      spec {
        container {
          image = "nicholasjackson/fake-service:v0.7.8"
          name  = "payment"

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
            value = "payment successful from digitalocean."
          }

          env {
            name  = "NAME"
            value = "Payment"
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

          #       env {
          #         name  = "ERROR_TYPE"
          #         value = "http_error"
          #       }

          #       env {
          #         name  = "ERROR_CODE"
          #         value = "500"
          #       }

          #       env {
          #         name  = "ERROR_RATE"
          #         value = "0.5"
          #       }

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