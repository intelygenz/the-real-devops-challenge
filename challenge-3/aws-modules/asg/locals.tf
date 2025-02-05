locals {
  network_interfaces = [
    for idx, subnet_id in slice(var.subnet_ids,0,0): {
      associate_public_ip_address = false
      delete_on_termination       = true
      device_index                = idx
      subnet_id                   = subnet_id
      security_groups             = [var.default_sg]
    }
  ]
}