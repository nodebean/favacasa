terraform {
  required_version = ">= 1.11"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.71.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
  }
  cloud {
    organization = "beanteam"
    workspaces {
      name = "fava-casa-infra"
    }
  }
}


provider "proxmox" {
  endpoint = "https://10.10.8.11:8006/"
  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_USERNAME environment variable
  username = "root@pam"
  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_PASSWORD environment variable
  password = "some-password"
  insecure = true
}
