#!/bin/sh

## check if running as root ########
echo "Checking permission"
user=$(id -u)
if [ "$user" != 0 ]; then
	echo "Run script as root, exiting"
	exit 1 
fi
####################################

echo "Installing dependencies"
wget https://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u4_amd64.deb -O /tmp/libssl1.1_1.1.1w-0+deb11u4_amd64.deb
dpkg -i /tmp/libssl1.1_1.1.1w-0+deb11u4_amd64.deb

echo "Adding ZeroTier repository"
wget https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg -O /tmp/zt-gpg-key
gpg --dearmor < /tmp/zt-gpg-key > /usr/share/keyrings/zerotier-debian-package-key.gpg
wget https://raw.githubusercontent.com/awolfnet/vyos-install-zerotier/refs/heads/main/zerotier.list -O /tmp/zerotier.list
cp /tmp/zerotier.list /etc/apt/sources.list.d/zerotier.list

echo "Installing ZeroTier One package"
apt update
apt install zerotier-one=1.16.1

echo -n "Do you want to join a zerotier-one network now?[Y/n]:"
read -n 1 joinnetwork
echo

if [ -z "$joinnetwork" ]; then
    joinnetwork="y"
fi
if [ "${joinnetwork,,}" == 'y' ]; then
    echo -n "Enter Network ID to join: "
    read networkid
    if [ -z "$networkid" ]; then
        echo "No Network ID provided, exiting."
        exit 1
    fi
    mkdir -p /tmp/zerotier-one/networks.d/
    touch /tmp/zerotier-one/networks.d/$networkid.conf

    echo -n "Please input the interface name to bind ZeroTier to (eg. eth0) or press enter to skip: "
    read interfacename
    if [ -z "$interfacename" ]; then
        echo "No interface name provided, skipping binding."
    else
        echo "Binding ZeroTier to interface: $interfacename"
        echo "$networkid=$interfacename" >> /tmp/zerotier-one/devicemap
    fi
fi

