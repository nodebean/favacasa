locals {
  factory_url = "https://factory.talos.dev"
  platform    = "nocloud"
  arch        = "amd64"
  version     = var.kubernetes_cluster.talos_version

  schematic    = file("${path.module}/schematic.yaml")
  schematic_id = jsondecode(data.http.schematic_id.response_body)["id"]
  image_id     = "${local.schematic_id}_${local.version}"
}

data "http" "schematic_id" {
  url          = "${local.factory_url}/schematics"
  method       = "POST"
  request_body = local.schematic
}

resource "proxmox_virtual_environment_download_file" "this" {
  for_each = toset(distinct([for k, v in var.virtual_machines : "${v.host_node}_${local.image_id}"]))

  node_name    = split("_", each.key)[0]
  content_type = "iso"
  datastore_id = "local"

  file_name               = "${var.kubernetes_cluster.name}-talos-${split("_", each.key)[1]}-${split("_", each.key)[2]}-${local.platform}-${local.arch}.img"
  url                     = "${local.factory_url}/image/${split("_", each.key)[1]}/${split("_", each.key)[2]}/${local.platform}-${local.arch}.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.virtual_machines

  node_name = each.value.host_node

  name    = "${var.kubernetes_cluster.name}-${each.key}"
  on_boot = true
  started = true

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
    type  = "host"
  }

  memory {
    dedicated = each.value.ram_dedicated
  }

  network_device {
    bridge  = each.value.bridge
    vlan_id = var.kubernetes_cluster.vlan_id
  }

  # boot disk
  disk {
    datastore_id = each.value.datastore_id
    interface    = "scsi0"
    iothread     = true
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    file_format  = "raw"
    size         = each.value.os_disk_size
    file_id      = proxmox_virtual_environment_download_file.this["${each.value.host_node}_${local.image_id}"].id
  }

  # data disk
  disk {
    datastore_id = each.value.datastore_id
    interface    = "scsi1"
    iothread     = true
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    file_format  = "raw"
    size         = each.value.data_disk_size
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = each.value.datastore_id
    ip_config {
      ipv4 {
        address = "${each.value.ip}/${var.kubernetes_cluster.cidr}"
        gateway = var.kubernetes_cluster.gateway
      }
    }
  }
}