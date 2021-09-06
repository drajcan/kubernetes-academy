# --- networking/variables.tf ---

variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = string
}

variable "source_public_ip_prefix" {
  type = string
}

variable "instance_count" {
  type = string
}
