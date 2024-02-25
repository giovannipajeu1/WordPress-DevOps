variable "cloudinit_template_name" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "ssh_keys" {
  type = string
  sensitive = true
}

resource "proxmox_vm_qemu" "Worker-01" {
  count = 3
  name = "Worker-01${count.index + 1}"
  agent = 0
  target_node = var.proxmox_node
  bios = "seabios"
  boot = "c"
  cpu = "host"
  hotplug = "network,disk,usb"
  iso = "local:iso/debian-12.4.0-amd64-netinst.iso"
  kvm = true
  cores = 1
  sockets = 1
  memory = 512
  numa = false
  onboot = true
  startup = ""
  tablet = true
  vmid = 102
}