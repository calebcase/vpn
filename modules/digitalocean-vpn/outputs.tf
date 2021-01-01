output "public-ip" {
	value = digitalocean_floating_ip.vpn.ip_address
}

output "user-data" {
  value = local.user_data
}
