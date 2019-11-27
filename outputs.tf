output "k8s_config_aks" {
  value = module.aks.k8s_config
}

output "k8s_config_digitalocean" {
  value = module.digitalocean.k8s_config
}

output "aks_consul_addr" {
  value = module.aks.consul_public_ip
}

output "aks_web_addr" {
  value = module.aks.web_public_ip
}

output "aks_consul_gateway_addr" {
  value = module.aks.consul_gateway_addr
}

output "vms_consul_addr" {
  value = module.vms.consul_server_addr
}

output "vms_consul_gateway_addr" {
  value = module.vms.consul_gateway_addr
}

output "vms_payment_addr" {
  value = module.vms.payment_addr
}

output "vms_private_key" {
  value = module.vms.private_key
}

output "digitalocean_consul_addr" {
  value = module.digitalocean.consul_public_ip
}

output "digitalocean_consul_gateway_addr" {
  value = module.digitalocean.consul_gateway_addr
}