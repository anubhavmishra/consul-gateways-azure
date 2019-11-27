variable "project" {
  default = "consul-service-mesh"
}

variable "region" {
  default = "South India"
}

variable "client_id" {}
variable "client_secret" {}


variable "gcp_project" {
  description = "GCP project name"
  default     = "hc-da-test"
}

variable "gcp_region" {
  default = "asia-south1"
}

variable "google_zone_name" {
  description = "Domain name for demos"
  default     = "livedemosxyz"
}

variable "google_credentials" {
  type = "string"
}

## DigitalOcean

variable "digitalocean_token" {}

variable "digitalocean_region" {
  default = "blr1"
}
