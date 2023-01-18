terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.8"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://proxmox:8006/api2/json"
  pm_api_token_id = var.proxmox_user
  pm_api_token_secret = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "controlplane" {
  count = 1
  name = "controlplane-0${count.index + 1}"
  target_node = "pve"
  vmid = "40${count.index + 1}"
  clone = "k8s-template-20.04"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "50G"
    type = "scsi"
    storage = "vms-disks"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.100.4${count.index + 1}/24,gw=192.168.100.254"
  nameserver = "192.168.100.254"
}

resource "proxmox_vm_qemu" "kube-node" {
  count = 2
  name = "kube-node-0${count.index + 1}"
  target_node = "pve"
  vmid = "50${count.index + 1}"

  clone = "k8s-template-20.04"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "50G"
    type = "scsi"
    storage = "vms-disks"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=192.168.100.5${count.index + 1}/24,gw=192.168.100.254"
  nameserver = "192.168.100.254"
}

output "kube-node_ip_address" {
  description = "Current IP Default"
  value = proxmox_vm_qemu.kube-node.*.default_ipv4_address
}

output "controlplane_ip_address" {
  description = "Current IP Default"
  value = proxmox_vm_qemu.controlplane.*.default_ipv4_address
}