# --- computing/main.tf ---

### Create virtual machine
resource "azurerm_virtual_machine" "virtual_machine" {
  depends_on = [
    resource.azurerm_network_interface.interface
  ]

  count                 = var.instance_count
  name                  = "${var.project}-vm-${terraform.workspace}-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_size               = var.vm_size
  network_interface_ids = [resource.azurerm_network_interface.interface[count.index].id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.project}-disk-${terraform.workspace}-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.project}-vm-${terraform.workspace}-${count.index + 1}"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file(var.ssh_public_key_path)
      path     = "/home/ubuntu/.ssh/authorized_keys"
    }
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  tags = {
    Name        = "${var.project}-vm-${count.index + 1}"
    Project     = var.project
    Environment = terraform.workspace
  }
}

### Create network interface
resource "azurerm_network_interface" "interface" {
  count               = var.instance_count
  name                = "${var.project}-nic-${terraform.workspace}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.project}-subnet-${terraform.workspace}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id[count.index]
  }

  tags = {
    Name        = "${var.project}-interface"
    Project     = var.project
    Environment = terraform.workspace
  }
}

### Associate network interface with security group
resource "azurerm_network_interface_security_group_association" "security_group_interface_association" {
  count                     = var.instance_count
  network_interface_id      = resource.azurerm_network_interface.interface[count.index].id
  network_security_group_id = var.security_group_id
}

data "azurerm_public_ip" "public_ip" {
  depends_on = [
    resource.azurerm_virtual_machine.virtual_machine
  ]

  count               = var.instance_count
  name                = "${var.project}-ip-${terraform.workspace}-${count.index + 1}"
  resource_group_name = var.resource_group_name
}
