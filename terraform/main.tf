# --- root/main.tf ---

### Create resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project}-rg-${terraform.workspace}"
  location = "West Europe"
  tags = {
    Name        = "${var.project}-rg"
    Project     = var.project
    Environment = terraform.workspace
  }
}

### Get info about create resource group (due to missing attribute location)
data "azurerm_resource_group" "resource_group" {
  depends_on = [
    resource.azurerm_resource_group.resource_group
  ]

  name = "${var.project}-rg-${terraform.workspace}"
}

### Get local source public IP to allow SSH, HTTP, HTTPS connectivity
data "http" "source_public_ip" {
  url = var.http_info_ip_url
}

### Create resources from module networking
module "networking" {
  source                  = "./networking"
  project                 = var.project
  location                = data.azurerm_resource_group.resource_group.location
  resource_group_name     = "${var.project}-rg-${terraform.workspace}"
  address_space           = local.deployment.address_space
  source_public_ip_prefix = "${data.http.source_public_ip.body}/32"
  instance_count          = local.deployment.instance_count
}

### Create resources from module computing
module "computing" {
  source              = "./computing"
  project             = var.project
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = "${var.project}-rg-${terraform.workspace}"
  subnet_id           = module.networking.subnet_id
  security_group_id   = module.networking.security_group_id
  public_ip_id        = module.networking.public_ip_id
  vm_size             = local.deployment.vm_size
  ssh_public_key_path = var.ssh_public_key_path
  instance_count      = local.deployment.instance_count
}

### Create ansible inventory file
resource "local_file" "ansible_inventory" {
  content  = join("\n", module.computing.ansible_hosts)
  filename = "${var.ansible_inventory_file_path}/inventory-${terraform.workspace}"
}
