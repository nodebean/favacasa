locals {
  kubernetes_cluster = {
    name     = "favacasa"
    gateway  = "10.10.8.1"
    cidr     = 24
    endpoint = "10.10.8.12"
    kubernetes_version = "v1.30.10"
  }

  virtual_machines = {
    "node1" = {
      host_node      = "pve"
      machine_type   = "controlplane"
      ip             = "10.10.8.12"
      cpu            = 2
      ram_dedicated  = 12288
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }
    "node2" = {
      host_node      = "pve"
      machine_type   = "worker"
      ip             = "10.10.8.13"
      cpu            = 2
      ram_dedicated  = 12288
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }

    "node3" = {
      host_node      = "pve"
      machine_type   = "worker"
      ip             = "10.10.8.14"
      cpu            = 2
      ram_dedicated  = 12288
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-lvm"
      bridge         = "vmbr0"
    }
  }
}

module "virtual_machine" {
  source = "./modules/virtual-machine"

  virtual_machines   = local.virtual_machines
  kubernetes_cluster = local.kubernetes_cluster
}

module "kubernetes" {
  source = "./modules/kubernetes"

  depends_on                        = [module.virtual_machine]
  kubernetes_cluster                = local.kubernetes_cluster
  kubernetes_nodes                  = local.virtual_machines
  enable_talos_cluster_health_check = true
}
