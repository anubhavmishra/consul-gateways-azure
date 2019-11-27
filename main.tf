terraform {
  required_providers {
    google = ">= 2.20"
  }
}

#terraform {
# backend "remote" {
#   hostname     = "app.terraform.io"
#   organization = "mishracorp"
#
#   workspaces {
#     name = "consul-service-mesh-gateways-demo"
#   }
# }
#}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.project
  location = var.region

  tags = {
    environment = "DoNotDelete"
  }
}

module "aks" {
  source = "./aks"

  project        = var.project
  resource_group = azurerm_resource_group.aks_rg.name
  location       = azurerm_resource_group.aks_rg.location

  client_nodes = 3

  # Azure client id and secret to allow K8s to create loadbalancers
  client_id     = var.client_id
  client_secret = var.client_secret
}

module "vms" {
  source = "./vms"

  project        = var.project
  resource_group = azurerm_resource_group.aks_rg.name
  location       = azurerm_resource_group.aks_rg.location

  consul_primary_addr = module.aks.consul_public_ip
}

module "digitalocean" {
  source = "./digitalocean"

  project = var.project
  region  = var.digitalocean_region

  client_nodes = 3

  digitalocean_token = var.digitalocean_token

  consul_primary_addr = module.aks.consul_public_ip
}
