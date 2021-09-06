# --- networking/outputs.tf ---

output "source_public_ip_prefix" {
  value = var.source_public_ip_prefix
}

output "subnet_id" {
  value = resource.azurerm_subnet.subnet.id
}

output "public_ip_id" {
  value = resource.azurerm_public_ip.public_ip[*].id
}

output "security_group_id" {
  value = resource.azurerm_network_security_group.security_group.id
}
