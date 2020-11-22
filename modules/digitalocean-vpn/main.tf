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
  user_data = <<EOT
#!/bin/bash
set -euo pipefail
set -x

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

# Install Wireguard Tooling
apt-get install -y wireguard

# Configure Traffic Forwarding
cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
EOF

sysctl -p

mkdir -p /etc/wireguard
cat >> /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = ${var.server-private-ip}/24
PrivateKey = ${var.server-key}
ListenPort = 51820

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

%{for i, key in var.client-public-keys}
[Peer]
PublicKey = ${key}
AllowedIPs = ${var.client-private-ips[i]}/32
%{endfor}
EOF

wg-quick up wg0
systemctl enable wg-quick@wg0.service

apt-get install -y unbound unbound-host
curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache
chown -R unbound:unbound /var/lib/unbound

cat > /etc/unbound/unbound.conf <<EOF
server:
  num-threads: 4
  verbosity: 1

  root-hints: "/var/lib/unbound/root.hints"

  interface: 0.0.0.0
  max-udp-size: 3072

  access-control: 0.0.0.0/0 refuse
  access-control: 127.0.0.1 allow
  access-control: ${var.server-private-ip}/24 allow

  private-address: ${var.server-private-ip}/24

  hide-identity: yes
  hide-version: yes

  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-referral-path: yes

  unwanted-reply-threshold: 10000000

  val-log-level: 1

  cache-min-ttl: 1800

  cache-max-ttl: 14400
  prefetch: yes
  prefetch-key: yes

  include: "/etc/unbound/unbound.conf.d/*.conf"
EOF
GEN

cat <<'GEN'
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved.service

cat > /etc/resolv.conf <<EOF
nameserver 127.0.0.1
options edns0
EOF

systemctl enable unbound
systemctl start unbound

# Needed to get it to bind the interfaces correctly apparently.
systemctl restart unbound

# Blacklist Setup
# https://github.com/StevenBlack/hosts/blob/master/readme.md
# https://deadc0de.re/articles/unbound-blocking-ads.html

cat > /usr/bin/unbound-rebuild-blacklist <<'EOF'
#!/bin/bash
set -euo pipefail

wget -O - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts \
  | grep '^0\.0\.0\.0' \
  | awk '{print "local-zone: \""$2"\" redirect\nlocal-data: \""$2" A 0.0.0.0\""}' \
  > /tmp/blacklist.conf

mv /tmp/blacklist.conf /etc/unbound/unbound.conf.d/blacklist.conf

systemctl restart unbound
EOF

chmod u+x /usr/bin/unbound-rebuild-blacklist

ln -s /usr/bin/unbound-rebuild-blacklist /etc/cron.daily/
unbound-rebuild-blacklist
GEN
EOT
}

