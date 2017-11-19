resource "kubernetes_pod" "data" {
  metadata {
    name = "data"
    labels {
      app = "data"
    }
  }

  spec {
    container {
      image = "crosscite/content-negotiation:latest"
      name  = "data"
    }
  }
}

resource "kubernetes_service" "data" {
  metadata {
    name = "data"
  }
  spec {
    selector {
      app = "${kubernetes_pod.data.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = "${var.service-ports["data"]}"
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_replication_controller" "data" {
  metadata {
    name = "data"
    labels {
      app = "data"
    }
  }

  spec {
    replicas = "1"
    selector {
      app = "data"
    }
    template {
      container {
        image = "crosscite/content-negotiation:latest"
        name  = "data"

        resources{
          limits{
            cpu    = "0.5"
            memory = "512Mi"
          }
        }
      }
    }
  }
}
