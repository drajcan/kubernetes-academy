### root/main.tf ###

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.username}-resource_group"
  location = var.location

  tags = {
    Name    = "${var.username}-resource_group"
    Project = var.username
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.username}-virtual_network"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = [var.address_space]

  tags = {
    Name    = "${var.username}-virtual_network"
    Project = var.username
  }
}

resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count
  name                 = "${var.username}-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [ cidrsubnet(var.address_space, 8, count.index + 1) ]
}

resource "azurerm_lb" "loadbalancer" {
  name                = "${var.username}-loadbalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  frontend_ip_configuration {
    name = "${var.username}-frontend_ip_configuration"
    subnet_id = azurerm_subnet.subnet[0].id
  }

  tags = {
    Name    = "${var.username}-loadbalancer"
    Project = var.username
  }
}
