# --- root/locals.tf ---

locals {
  deployment = {
    address_space  = var.environment[terraform.workspace]["address_space"]
    instance_count = var.environment[terraform.workspace]["instance_count"]
    vm_size        = var.environment[terraform.workspace]["vm_size"]
  }
}
