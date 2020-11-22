variable "server-key" {
  type        = string
  description = "Server Key: Generate via `wg genkey`"
}

variable "server-public-key" {
  type        = string
  description = "Server Key: Generate via `wg pubkey < server/key` assuming you generated a key via `wg genkey > server/key`"
}

variable "client-public-keys" {
  type        = list(string)
  description = "Client Keys: Generate via `wg pubkey < client/key` assuming you generated a key via `wg genkey > client/key`"
}

variable "ssh-key-location" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
