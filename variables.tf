variable "project" {
  default = "consul-service-mesh"
}

variable "region" {
  default = "West US"
}

variable "client_id" {}
variable "client_secret" {}


variable "gcp_project" {
  description = "GCP project name"
  default     = "hc-da-test"
}

variable "gcp_region" {
  default = "us-west1"
}

variable "domain" {
  description = "Domain name for demos"
  default     = "hashicorp.live"
}

variable "google_credentials" {
  type = "string"
}

## DigitalOcean

variable "digitalocean_token" {}

variable "digitalocean_region" {
  default = "sfo2"
}
