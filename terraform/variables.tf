variable "proxmox_user" {}
variable "proxmox_password" {}

variable "proxmox_url" {
    default = "https://proxmox:8006/api2/json"
}

variable "template_name" {
    default = "k8s-template-20.04"
}

variable "disk_size" {
  default = "50G"
}

variable "gw_ns" {
  default = "192.168.100.254"
}

variable "ssh_key_path" {
  default = "~/.ssh/proxmox"
}