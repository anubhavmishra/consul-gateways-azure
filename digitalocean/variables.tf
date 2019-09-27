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

variable "consul_primary_addr" {}