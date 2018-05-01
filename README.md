# docker-pulsesecure-cert

Dockerized Pulse Secure VPN connection using:

> http://www.infradead.org/openconnect/

This is only a simple implementation to simplify the connection in linux 
without the official Pulse Secure client (that never works). Only works 
with certifciate authentication, no username or password. This image is 
forked from
jamgocoop/docker-pulsesecure-vpn, look there for username/password 
authentication.

# How to use this image

# Certificate only connect:
	
	docker run --name \
		pulsevpn \
		-e "VPN_URL=<vpn_connect_url>" \
		-e "OPENCONNECT_OPTIONS=<openconnect_extra_options>" \
                -v /full/path/cert.pem:/root/cert.pem:ro \
                -v /full/path/private.key:/root/private.key:ro \
                -v /full/path/ca.pem:/root/ca.pem:ro \
		--privileged=true \
		-d mathiaslaver/docker-pulsesecure-vpn
	

## Add routes
Once started you can route subnets from host via docker container:

    #! /bin/bash
    PULSESECURE_DOCKER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' pulsevpn)"
    if [ -z "$PULSESECURE_DOCKER_IP" ]; then
    	echo >&2 'error: missing PULSESECURE_DOCKER_IP, is pulsevpn docker running?'
    	exit 1;
    fi
    sudo route add -net a.b.c.0 netmask 255.255.255.0 gw $PULSESECURE_DOCKER_IP
    sudo route add -net x.y.z.0 netmask 255.255.255.0 gw $PULSESECURE_DOCKER_IP
    ...
