output "kube_config" {
  value     = module.kubernetes.kube_config
  sensitive = true
}

output "talos_config" {
  description = "Talos configuration file"
  value       = module.kubernetes.talos_config
  sensitive   = true
}
