kind = "service-resolver"
name = "payment"

failover = {
  "*" = {
    datacenters = ["dc2", "dc3"]
  }
}
