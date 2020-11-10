# VPN Infrastructure Management Tooling

This is in no way a polished user experience. This is just a set of scripts I
found useful for setting up VPNs in different regions. My goals were:

* having repeatable deployments
* generating configurations for clients
* getting a new IP for traffic (while not reconfiguring all the clients)

## Pre-requisites

The following CLI tools are required:

* bash
* doctl
* wg
* jq
* qrencode

## Setup

Copy the examples and modify them:

```
$ cp -R server.d.example server.d
$ cp -R client.d.example client.d
```

Create a new server config by renaming the example:

```
mv server.d/example server.d/nyc
```

Generate a new key for the server:

```
wg genkey > server.d/nyc/key
```

Update the server with a static public IP. This needs to be a public IP you
have created in Digital Ocean already:

```
echo '1.2.3.4' > server.d/nyc/public.ip
```

Update the server with your SSH key fingerprint. This should already be
registered with Digital Ocean.

```
echo 'yo:ur:ke:y :he:re' > server.d/nyc/ssh-keys
```

When setting the private IPs it is important that the clients and the server
are in the same subnet. The defaults should be fine, but remember this if you
change the server private IP or if you have a lot of clients.

Create a new client config by renaming the example:

```
mv client.d/example client.d/computer
```

Avoid overlapping IPs when updating the `client.d/computer/ip` file.

Generate client config information and QR:

```
./client-config client.d/computer server.d/nyc
```

Build the server:

```
./build server.d/nyc
```

The server can be rebuilt at any time with the above command and will get a new
public IP.

## Debugging

Validate server config with:

```
./server-config client.d server.d/nyc
```

Check the server setup script:

```
./user-data client.d server.d/nyc
```
