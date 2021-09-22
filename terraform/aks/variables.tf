# --- root/variables.tf ---

variable "project" {
  type = string
}

variable "tenant_id" {
  type    = string
  default = "39a3b01c-a3ef-495b-a5ad-b1d0ee62025e"
}

variable "kubernetes_version" {
  type = string
  default = "1.21.2"
}

variable "location" {
  type = string
  default = "West Europe"  
}

variable "dns_prefix" {
  type = string
  default = "k8s-academy"
}

variable "vm_size" {
  type = string
  default = "Standard_D2_v2"
}

variable "node_count" {
  type = number
  default = 2
}

variable "enable_auto_scaling" {
  type = bool
  default = false
}
