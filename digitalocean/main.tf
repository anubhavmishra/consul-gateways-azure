# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_kubernetes_cluster" "consul" {
  name    = "${var.project}"
  region  = "${var.region}"
  version = "${var.kubernetes_version}"
  tags    = ["consul"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = "${var.client_nodes}"
  }
}
