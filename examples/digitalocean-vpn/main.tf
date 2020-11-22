terraform {
  required_version = ">= 0.13"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

module "vpn1" {
  source = "./modules/digitalocean-vpn"

  server-key        = var.server-key
  server-public-key = var.server-public-key

  client-key        = var.client-key
  client-public-key = var.client-public-key
}

resource "local_file" "vpn1" {
  content = module.vpn1.client-config
  filename = "vpn1.conf"
}
