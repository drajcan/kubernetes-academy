### root/outputs.tf

output "resource_group_id" {
  value = azurerm_resource_group.resource_group.id
}

output "loadbalancer_private_ip" {
  value = azurerm_lb.loadbalancer.private_ip_address
}

output "subnet_cidrs" {
  value = azurerm_subnet.subnet[*].address_prefix
}
