output "client-config" {
  value = <<EOT

[Interface]
Address = ${var.client-private-ip}/24
PrivateKey = ${var.client-key}
DNS = ${var.server-private-ip}

[Peer]
PublicKey = ${var.server-public-key}
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = ${digitalocean_floating_ip.vpn.ip_address}:51820
EOT
}
