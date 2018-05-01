#!/bin/sh
set -e
set -x

openconnect -q --cookieonly $OPENCONNECT_OPTIONS --disable-ipv6 -c /root/cert.pem -k /root/private.key --protocol=nc --os=linux $VPN_URL --no-passwd | openconnect $OPENCONNECT_OPTIONS -b --disable-ipv6 -c /root/cert.pem -k /root/private.key --protocol=nc --os=linux $VPN_URL --cookie-on-stdin

iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A FORWARD -i eth0 -j ACCEPT
