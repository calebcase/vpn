output "public-ip" {
	value = digitalocean_floating_ip.vpn.ip_address
}
