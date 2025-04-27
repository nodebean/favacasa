resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.kubernetes_cluster.name
  cluster_endpoint   = "https://${var.kubernetes_cluster.endpoint}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_cluster.kubernetes_version
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.kubernetes_cluster.name
  cluster_endpoint   = "https://${var.kubernetes_cluster.endpoint}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_cluster.kubernetes_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.kubernetes_cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "controlplane"]
  nodes                = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "worker"]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each = {
    for k, v in var.kubernetes_nodes : k => v
    if v.machine_type == "controlplane"
  }
  node = each.value.ip
  config_patches = [
    templatefile("${path.module}/talos-config/control-plane.yaml.tmpl", {
      hostname     = "${var.kubernetes_cluster.name}-${each.key}"
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each = {
    for k, v in var.kubernetes_nodes : k => v
    if v.machine_type == "worker"
  }
  node = each.value.ip
  config_patches = [
    templatefile("${path.module}/talos-config/worker.yaml.tmpl", {
      hostname     = "${var.kubernetes_cluster.name}-${each.key}"
      install_disk = each.value.install_disk
    }),
  ]
}
resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "controlplane"][0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "controlplane"][0]
}

data "talos_cluster_health" "this" {
  count = var.enable_talos_cluster_health_check ? 1 : 0
  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_configuration_apply.worker,
    talos_machine_bootstrap.this
  ]
  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "controlplane"]
  worker_nodes           = [for k, v in var.kubernetes_nodes : v.ip if v.machine_type == "worker"]
  endpoints              = data.talos_client_configuration.this.endpoints
  skip_kubernetes_checks = true

  timeouts = {
    read = "10m"
  }
}
