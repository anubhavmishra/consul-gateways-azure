variable "digitalocean_token" {}

variable "project" {
  default = "example"
}

variable "region" {
  default = "nyc1"
}

variable "client_nodes" {
  default = 3
}

variable "kubernetes_version" {
  default = "1.16.2-do.0"
}

variable "consul_primary_addr" {}