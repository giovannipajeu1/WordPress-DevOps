variable "do_token" {
  type    = string
  default = ""
}

variable "vm-wordpress-count" {
  type    = number
  default = 2
  validation {
    condition     = var.vm-wordpress-count > 1
    error_message = "O número minimo de maquinas é 2"
  }
}

variable "ssh_keys" {
  type    = string
  default = "WSL"
}