resource "metal_device" "sno" {
  depends_on = [
    local.user_data_vars,
  ]  hostname         = var.node_hostname
  operating_system = "custom_ipxe"
  ipxe_script_url  = "http://${var.bastion_ip}:8080/sno.ipxe"
  plan             = var.node_size
  facilities       = var.facility == "" ? null : [var.facility]
  billing_cycle    = var.billing_cyle
  project_id       = var.project_id
  hardware_reservation_id = lookup(var.reservations, var.node_hostname, "")
  ip_address {
    type = "private_ipv4"
  }
}

resource "metal_port_vlan_attachment" "node_priv_vlan_attach" {
  depends_on = [
    metal_device.node
  ]

  device_id = metal_device.node.id
  port_name = "bond0"
  vlan_vnid = var.private_vlans[0].vxlan
}
