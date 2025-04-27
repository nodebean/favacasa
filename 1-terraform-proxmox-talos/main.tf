locals {
  kubernetes_cluster = {
    name               = "favacasa"
    gateway            = "10.10.13.1"
    cidr               = 24
    endpoint           = "10.10.13.51"
    kubernetes_version = "v1.30.10"
  }

  virtual_machines = {
    "controlplane1" = {
      host_node      = "pve"
      vm_id          = 1351
      machine_type   = "controlplane"
      ip             = "10.10.13.51"
      cpu            = 2
      ram_dedicated  = 4096
      os_disk_size   = 10
      data_disk_size = 32
      datastore_id   = "local-zfs"
      bridge         = "vmbr1"
    }
    "controlplane2" = {
      host_node      = "pve"
      vm_id          = 1352
      machine_type   = "controlplane"
      ip             = "10.10.13.52"
      cpu            = 2
      ram_dedicated  = 4096
      os_disk_size   = 10
      data_disk_size = 32
      datastore_id   = "local-zfs"
      bridge         = "vmbr1"
    }
    "worker1" = {
      host_node      = "pve"
      vm_id          = 1353
      machine_type   = "worker"
      ip             = "10.10.13.53"
      cpu            = 8
      ram_dedicated  = 16384
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-zfs"
      bridge         = "vmbr1"
    }

    "worker2" = {
      host_node      = "pve"
      vm_id          = 1354
      machine_type   = "worker"
      ip             = "10.10.13.54"
      cpu            = 8
      ram_dedicated  = 16384
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-zfs"
      bridge         = "vmbr1"
    }
    "worker3" = {
      host_node      = "pve"
      vm_id          = 1355
      machine_type   = "worker"
      ip             = "10.10.13.55"
      cpu            = 8
      ram_dedicated  = 16384
      os_disk_size   = 10
      data_disk_size = 128
      datastore_id   = "local-zfs"
      bridge         = "vmbr1"
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
