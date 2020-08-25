#!/bin/bash

# Developped by tebybiteOverride
# cuz fuck the network manager

echo "Adding new WIFI Network:"
echo "NETWORK NAME:"
read ssid
echo "PASSWORD:"
read passwd
clear
passwdhash=`wpa_passphrase "$ssid" "$passwd" | tail -n 2 | head -n 1 | sed -e "s/psk=//" | tr -d "\n\t"`
name=`echo "w_$ssid" | sed -e "s/ /_/g"`
echo -e "\n#$ssid\nallow-hotplug wlan0=$name\niface $name inet dhcp\nwpa-ssid \"$ssid\"\nwpa-psk $passwdhash\n" >> /etc/network/interfaces
echo "shutting down wifi interface..."
ifdown wlan0 1> /dev/null 2> /dev/null
echo "activating new wifi interface..."
ifup wlan0=$name 1> /dev/null 2> /dev/null
echo "done."
echo "testing..."
ping -c 4 1.1.1.1 2> /dev/null 1>&2
if [ $? == 0 ]
then
	echo "successfully connected to internet."
else
	echo "internet unreachable."
fi
echo "DONE."
