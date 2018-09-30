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
qemuCommand=$(which qemu-system-x86_64)
if [ -z $qemuCommand ]
then
  sudo apt install qemu-system-x86
  sudo adduser $USER kvm
fi
if [ ! -f "$filename" ]
then
  wget -O "$filename" "$1"
fi
rm -f vm01disk
qemu-img create -f raw vm01disk 20G
qemu-system-x86_64 -vga virtio -enable-kvm -cdrom "$filename" -smp 2 -m 2G -drive file=vm01disk,format=raw &
wmctrl -a QEMU -e '0,1,1,1920,1080'
