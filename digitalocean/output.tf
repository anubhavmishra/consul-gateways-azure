output "k8s_config" {
  value = digitalocean_kubernetes_cluster.consul.kube_config.0.raw_config
}

output "consul_public_ip" {
  value = kubernetes_service.consul.load_balancer_ingress.0.ip
}

output "consul_gateway_addr" {
  value = kubernetes_service.gateways.load_balancer_ingress.0.ip
}
