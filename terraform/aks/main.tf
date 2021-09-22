# --- root/main.tf ---

### Create resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.project}-rg"
  location = "${var.location}"
  tags = {
    Name        = "${var.project}-rg"
    Project     = var.project
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project}-aks"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "${var.dns_prefix}"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    node_count = "${var.node_count}"
    vm_size    = "${var.vm_size}"
    availability_zones = [ "1", "2", "3" ]
    enable_auto_scaling = var.enable_auto_scaling

    node_labels = {
      Environment = terraform.workspace
      Project = var.project
    }
  }

  kubernetes_version = var.kubernetes_version

  tags = {
    Environment = terraform.workspace
    Project = var.project
    Name = "${var.project}-aks"
  }
}
