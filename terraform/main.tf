resource "proxmox_vm_qemu" "controlplane" {
  count = 1
  name = "controlplane-0${count.index + 1}"
  target_node = "pve"
  vmid = "40${count.index + 1}"
  clone = var.template_name

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
    size = var.disk_size
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
  ipconfig0 = "ip=192.168.100.4${count.index + 1}/24,gw=${var.gw_ns}"
  nameserver = var.gw_ns
}

resource "proxmox_vm_qemu" "kube-node" {
  count = 2
  name = "kube-node-0${count.index + 1}"
  target_node = "pve"
  vmid = "50${count.index + 1}"

  clone = var.template_name

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
    size = var.disk_size
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
  ipconfig0 = "ip=192.168.100.5${count.index + 1}/24,gw=${var.gw_ns}"
  nameserver = var.gw_ns
}