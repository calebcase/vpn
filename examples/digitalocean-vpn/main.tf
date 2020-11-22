terraform {
  required_version = ">= 0.13"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

resource "digitalocean_ssh_key" "default" {
  name       = "My SSH key"
  public_key = file(var.ssh-key-location)
}

module "vpn1" {
  source = "./modules/digitalocean-vpn"

  server-key        = var.server-key
  server-public-key = var.server-public-key

  client-public-keys = var.client-public-keys

  ssh-key-fingerprint = digitalocean_ssh_key.default.fingerprint
}

module "vpn2" {
  source = "./modules/digitalocean-vpn"

  region            = "nyc1"
  server-key        = var.server-key
  server-public-key = var.server-public-key

  client-public-keys = var.client-public-keys

  ssh-key-fingerprint = digitalocean_ssh_key.default.fingerprint
}
