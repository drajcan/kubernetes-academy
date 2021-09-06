# --- computing/outputs.tf ---

output "ansible_hosts" {
  value = [for x in range(length(data.azurerm_public_ip.public_ip[*])) : "vm${x + 1} ansible_host=${data.azurerm_public_ip.public_ip[x].ip_address} ansible_connection=ssh ansible_user=ubuntu"]
}

output "virtual_machines" {
  value = [for x in range(length(data.azurerm_public_ip.public_ip[*])) : "name=${regex("[^\\/]+$", resource.azurerm_virtual_machine.virtual_machine[x].id)} private_ip=${azurerm_network_interface.interface[x].private_ip_address} public_ip=${data.azurerm_public_ip.public_ip[x].ip_address} project=${var.project} environment=${terraform.workspace}"]
}
