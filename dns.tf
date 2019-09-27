provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  credentials = "${var.google_credentials}"
}

data "google_project" "project" {}

data "google_dns_managed_zone" "hashicorp_live" {
  name = "hashicorplive"
}

resource "google_dns_record_set" "consul_azure" {
  name = "consul.${data.google_dns_managed_zone.hashicorp_live.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = "${data.google_dns_managed_zone.hashicorp_live.name}"

  rrdatas = [module.aks.consul_public_ip]
}

resource "google_dns_record_set" "web_azure" {
  name = "web.${data.google_dns_managed_zone.hashicorp_live.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = "${data.google_dns_managed_zone.hashicorp_live.name}"

  rrdatas = [module.aks.web_public_ip]
}
