#!/bin/sh
#Start wlan0 interface with default wifi network

wpa_supplicant -B -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
dhclient
