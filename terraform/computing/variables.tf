# --- computing/variables.tf ---

variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "public_ip_id" {
  type = list(any)
}

variable "vm_size" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "instance_count" {
  type = string
}
