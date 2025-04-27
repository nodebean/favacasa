variable "kubernetes_cluster" {
  type = object({
    name               = string
    endpoint           = string
    kubernetes_version = string
  })
}

variable "kubernetes_nodes" {
  type = map(object({
    machine_type = string
    ip           = string
    install_disk = optional(string, "/dev/sda")
  }))
}

variable "enable_talos_cluster_health_check" {
  description = "Enable Talos cluster health check"
  type        = bool
  default     = true
}
