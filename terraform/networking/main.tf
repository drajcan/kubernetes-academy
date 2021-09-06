# --- networking/main.tf ---

### Create network
resource "azurerm_virtual_network" "network" {
  name                = "${var.project}-network-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]

  tags = {
    Name        = "${var.project}-network"
    Project     = var.project
    Environment = terraform.workspace
  }
}

### Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-subnet-${terraform.workspace}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = resource.azurerm_virtual_network.network.name
  address_prefixes = [
    cidrsubnet(var.address_space, 8, 0)
  ]
}

### Create network security group
resource "azurerm_network_security_group" "security_group" {
  name                = "${var.project}-sg-${terraform.workspace}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Name        = "${var.project}-sg"
    Project     = var.project
    Environment = terraform.workspace
  }
}

### Create network security rule for SSH
resource "azurerm_network_security_rule" "security_rule_SSH" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.source_public_ip_prefix
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = resource.azurerm_network_security_group.security_group.name
}

### Create network security rule for HTTP
resource "azurerm_network_security_rule" "security_rule_HTTP" {
  name                        = "HTTP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.source_public_ip_prefix
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = resource.azurerm_network_security_group.security_group.name
}

### Create network securityle rule for HTTPS
resource "azurerm_network_security_rule" "security_rule_HTTPS" {
  name                        = "HTTPS"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.source_public_ip_prefix
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = resource.azurerm_network_security_group.security_group.name
}

### Create public IP address
resource "azurerm_public_ip" "public_ip" {
  count               = var.instance_count
  name                = "${var.project}-ip-${terraform.workspace}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_version          = "IPv4"
  allocation_method   = "Dynamic"

  tags = {
    Name        = "${var.project}-ip"
    Project     = var.project
    Environment = terraform.workspace
  }
}
