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
* jq

An existing Digital Ocean account and API token is required which should be exported under the `DIGITALOCEAN_TOKEN` environment variable.

## Expedited Setup
If you want an instant VPN with a single server and client with sane default settings, simply run `make`.

## Setup

This project generates terraform for VPN servers based on a `config.json` which allows you to specify multiple clients and servers. A basic functional `config.json` can be created via `make config.json` and used as a starting point. A more complicated config would look something like the below:

```json
{
	"vpn1": {
		"image": "ubuntu-20-04-x64",
		"instance_size": "s-1vcpu-1gb",
		"region": "nyc1",
		"private_ip": "10.10.10.1",
		"private_key": "<server-key>",
		"clients": [
			{
				"private_ip": "10.10.10.2",
				"private_key": "<client-key>"
			},
			{
				"private_ip": "10.10.10.3",
				"private_key": "<client-key>"
			}
		]
	},
	"vpn2": {
		"image": "ubuntu-20-04-x64",
		"instance_size": "s-1vcpu-1gb",
		"region": "nyc2",
		"private_ip": "10.10.10.5",
		"private_key": "<server-key>",
		"clients": [
			{
				"private_ip": "10.10.10.2",
				"private_key": "<client-key>"
			},
			{
				"private_ip": "10.10.10.3",
				"private_key": "<client-key>"
			}
		]
	}
}

```

A `main.tf` file will be generated based on this config and can be invoked from the Makefile. An existing Digital Ocean SSH key can be provided via the environment variable `SSH_KEY_FINGERPRINT`, otherwise the terraform will use one located at `~/.ssh/id_rsa.pub` instead.

After this a simple `make apply` will create all the resources necessary to create your VPN.
TODO: Add client config generation.

## Destroy
`make destroy` will destroy all relevant resources.
