kind = "service-resolver"
name = "payment"

redirect {
  service    = "payment"
  datacenter = "dc3"
}