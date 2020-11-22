# VPN Infrastructure Management Tooling

This is in no way a polished user experience. This is just a set of scripts I
found useful for setting up VPNs in different regions. My goals were:

* having repeatable deployments
* generating configurations for clients
* getting a new IP for traffic (while not reconfiguring all the clients)

## Pre-requisites

The following CLI tools are required:

* bash
* wg
* terraform

## Setup
See `variables.tf` for full configuration options. Sane defaults are provided where applicable but Wireguard keys need to be created for the server and client via `wg genkey`. Corresponding public keys also must be generated via `wg pubkey < {private_key_file}`.

The recommended way to setup the project is to store these values in `my.tfvars` in the root of the directory like so:
```
client-keys = ["client-private-key1", "client-private-key2"]
client-public-keys = ["client-public-key1", "client-public-key2"]
server-key        = "server-private-key"
server-public-key = "server-public-key"
```

These variables can also be set via environment variables or on the CLI as described [here](https://www.terraform.io/docs/configuration/variables.html).

After this a simple `make apply` will create all the resources necessary to create your VPN. This will output a client config that looks something like this:
```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

client-config =
[Interface]
Address = 10.10.10.2/24
PrivateKey = <some key>
DNS = 10.10.10.1

[Peer]
PublicKey = <some key>
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = 45.55.121.157:51820
```
which can then be used with Wireguard. Congratulations!

## Destroy
`make destroy` will destroy all relevant resources.
