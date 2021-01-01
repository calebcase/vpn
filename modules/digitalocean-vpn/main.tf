resource "digitalocean_floating_ip" "vpn" {
  region = var.region
}

resource "digitalocean_floating_ip_assignment" "vpn" {
  ip_address = digitalocean_floating_ip.vpn.ip_address
  droplet_id = digitalocean_droplet.vpn.id
}

resource "digitalocean_droplet" "vpn" {
  name      = "my-vpn"
  size      = var.instance-size
  image     = var.image
  region    = var.region
  ssh_keys  = [var.ssh-key-fingerprint]
  user_data = local.user_data
}
