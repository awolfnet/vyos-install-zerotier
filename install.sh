#!/bin/sh
dpkg -i ./libssl1.1_1.1.1w-0+deb11u4_amd64.deb
gpg --dearmor < ./zt-gpg-key > /usr/share/keyrings/zerotier-debian-package-key.gpg
cp ./zerotier.list /etc/apt/sources.list.d/zerotier.list
apt update
apt install zerotier-one=1.16.1
cp ./devicemap /var/lib/zerotier-one/devicemap
mkdir -p /var/lib/zerotier-one/networks.d/
touch /var/lib/zerotier-one/networks.d/b15644912e0d0109.conf
