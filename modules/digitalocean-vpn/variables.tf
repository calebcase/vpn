variable "server-key" {
  type        = string
  description = "Server Key: Generate via `wg genkey`"
}

variable "server-public-key" {
  type        = string
  description = "Server Key: Generate via `wg pubkey < server/key` assuming you generated a key via `wg genkey > server/key`"
}

variable "client-key" {
  type        = string
  description = "Client Key: Generate via `wg genkey`"
}

variable "client-public-key" {
  type        = string
  description = "Client Key: Generate via `wg pubkey < client/key` assuming you generated a key via `wg genkey > client/key`"
}

variable "ssh-key-location" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "server-private-ip" {
  type    = string
  default = "10.10.10.1"
}

variable "client-private-ip" {
  type    = string
  default = "10.10.10.2"
}

variable "image" {
  type        = string
  description = "The Digital Ocean image slug or ID"
  default     = "ubuntu-20-04-x64"
}

variable "instance-size" {
  type        = string
  description = "The Digital Ocean instance size"
  default     = "s-1vcpu-1gb"
}

variable "region" {
  type        = string
  description = "The Digital Ocean region"
  default     = "nyc3"
}

