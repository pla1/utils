#!/bin/bash
#
# Try out an Linux operating system in a VM. Pass the download live ISO download URL.
#
if [ "$#" -ne 1 ]
then
  echo "Pass the ISO download URL. Example: ./tryos.sh http://cdimage.ubuntu.com/kubuntu/releases/18.04/release/kubuntu-18.04-desktop-amd64.iso"
  exit -1
fi
url="$1"
filename=$(basename "$url")
echo "File: $filename"
sudo apt install qemu-system-x86
if [ ! -f "/tmp/$filename" ]
then
  wget -O "/tmp/$filename" "$1"
fi
rm -f /tmp/vm01disk
qemu-img create -f raw /tmp/vm01disk 20G
sudo qemu-system-x86_64 -vga virtio -enable-kvm -cdrom "/tmp/$filename" -smp 2 -m 2G -drive file=/tmp/vm01disk,format=raw & 
wmctrl -a QEMU -e '0,1,1,1920,1080'
