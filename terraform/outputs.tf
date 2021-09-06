# --- root/outputs.tf ---

output "project_info" {
  description = "Info about created virtual machines"
  value       = [for x in module.computing[*] : x]
}
