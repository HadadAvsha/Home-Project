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
  pm_api_token_id = "terraform-prov@pve!terraform-prov-id"
  pm_api_token_secret = "8e015270-5f25-423d-93f3-b54d3227b5e6"
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
    #storage_type = "zfspool"
    # iothread = 1
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
    #storage_type = "zfspool"
    # iothread = 1
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


# resource "null_resource" "ips_to_txt" {

#   provisioner "local-exec" {
#         command = "bash ~/Desktop/lab/proxmox/terraform/prep.sh"
#   }
#   # depends_on = [output.controlplane_ip_address]
# }


# resource "proxmox_vm_qemu" "kube-storage" {
#   count = 1
#   name = "kube-storage-0${count.index + 1}"
#   target_node = "prox-1u"
#   vmid = "60${count.index + 1}"

#   clone = "ubuntu-2004-cloudinit-template"

#   agent = 1
#   os_type = "cloud-init"
#   cores = 2
#   sockets = 1
#   cpu = "host"
#   memory = 4096
#   scsihw = "virtio-scsi-pci"
#   bootdisk = "scsi0"

#   disk {
#     slot = 0
#     size = "20G"
#     type = "scsi"
#     storage = "local-zfs"
#     #storage_type = "zfspool"
#     iothread = 1
#   }

#   network {
#     model = "virtio"
#     bridge = "vmbr0"
#   }
  
#   network {
#     model = "virtio"
#     bridge = "vmbr17"
#   }

#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   ipconfig0 = "ip=10.98.1.6${count.index + 1}/24,gw=10.98.1.1"
#   ipconfig1 = "ip=10.17.0.6${count.index + 1}/24"
# #   sshkeys = <<EOF
# #   ${var.ssh_key}
# #   EOF
# }




# cat <<EOF | sudo tee /etc/docker/daemon.json
# {
# "exec-opts": ["native.cgroupdriver=systemd"],
# "log-driver": "json-file",
# "log-opts": {
# "max-size": "100m"
# },
# "storage-driver": "overlay2"
# }
# EOF


