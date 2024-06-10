#!/bin/bash
KER_VERSION=$(uname -a|awk '{ print $3}'|awk -F. '{print $1$2}')
DRI_VERSION=$(ls NVIDIA-Linux-x86_64* |awk -F- '{print $4}')
systemctl stop lightdm
systemctl stop vncserver@:1
#mhwd -i pci video-nvidia
modprobe acpi_call
sed -i "/Driver/a\\\\tBusID \"PCI:1:0:0\"" /etc/X11/mhwd.d/nvidia.conf
pacman -S linux$KER_VERSION-headers gcc make acpi_call-dkms xorg-xrandr xf86-video-intel git libglvnd lib32-libglvnd
chmod +x NVIDIA-Linux-x86_64-$DRI_VERSION
./NVIDIA-Linux-x86_64-$DRI_VERSION --kernel-source-path=/usr/src/linux$KER_VERSION
mkinitcpio -P
exit 0
