### root/variables.tf

# Required variables (parameters)
variable "username" {
  type = string
}

# Optional variables (parameters)
variable "location" {
  type    = string
  default = "West Europe"
}

variable "tenant_id" {
  type    = string
  default = "39a3b01c-a3ef-495b-a5ad-b1d0ee62025e"
}

variable "address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 3
}
