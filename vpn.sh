if [[ "$1" == "start" ]]; then
echo "Starting Docker container"
docker run --rm  --name \
        pulsevpn \
        -e "VPN_URL=https://remote.tt.se/dana-na/auth/url_4/welcome.cgi" \
        -e "OPENCONNECT_OPTIONS=-v --servercert pin-sha256:<yourstuffhere> \
        -v /full/path/certs/clientcert.pem:/root/cert.pem:ro \
        -v /full/path/certs/private.key:/root/private.key:ro \
        -v /full/path/certs/cacert.pem:/root/ca.pem:ro \
	--privileged=true \
	-d mathiaslaver/docker-pulsesecure-cert

echo "Sleeping for 3 seconds.."
sleep 3

# Look up IP of Docker container and add static routes

echo "Looking up container IP.."
PULSESECURE_DOCKER_IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' pulsevpn)"
if [ -z "$PULSESECURE_DOCKER_IP" ]; then
	echo >&2 'error: missing PULSESECURE_DOCKER_IP, is pulsevpn docker running?'
	exit 1;
fi

echo "Adding static routes"
# Not Arch
#sudo route add -net a.b.c.0 netmask 255.255.255.0 gw $PULSESECURE_DOCKER_IP
#sudo route add -net x.y.z.0 netmask 255.255.255.0 gw $PULSESECURE_DOCKER_IP

# Arch
sudo ip route add a.b.c.0/16 via $PULSESECURE_DOCKER_IP
sudo ip route add a.b.c.0/24 via $PULSESECURE_DOCKER_IP

# Set nameserver to server in tunnel
echo "Setting nameserver"
sudo sh -c "echo nameserver a.b.c.d > /etc/resolv.conf"

elif [[ "$1" == "stop" ]]; then
echo "Stopping Docker container"
docker stop pulsevpn
sudo sh -c "echo nameserver 1.1.1.1 > /etc/resolv.conf"

else
        echo "Please pass start or stop argument"; exit 1;
fi

