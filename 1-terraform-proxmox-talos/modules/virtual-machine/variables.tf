variable "kubernetes_cluster" {
  type = object({
    network_dhcp  = optional(bool, false)
    gateway       = string
    cidr          = number
    vlan_id       = optional(number, null)
    name          = string
    talos_version = optional(string, "v1.9.5")
  })
}

variable "virtual_machines" {
  type = map(object({
    host_node      = string
    vm_id          = optional(number, null)
    machine_type   = string
    datastore_id   = optional(string, "local-lvm")
    ip             = string
    bridge         = string
    cpu            = number
    ram_dedicated  = number
    os_disk_size   = number
    data_disk_size = number
  }))
}
