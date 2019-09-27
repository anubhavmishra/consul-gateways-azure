kind = "service-resolver"
name = "payment"

failover = {
  "*" = {
    datacenters = ["digitalocean", "vms"]
  }
}
