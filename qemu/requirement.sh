#!/bin/bash
sudo pacman -S ebtables dnsmasq firewalld ;
sudo systemctl restart libvirtd;
exit 0

