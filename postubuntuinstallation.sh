#!/bin/bash
#
# Install packages on a new Ubuntu installation.
# https://github.com/pla1/utils/blob/master/postubuntuinstallation.sh
#
sudo su
apt-get update
apt-get install clipit gimp hdhomerun-config openssh-server rdesktop git wireshark compizconfig-settings-manager pwgen ipcalc curl vpnc ttf-mscorefonts-installer guvcview git htop nmap iotop iperf screen whois mediainfo mplayer vlc python-pip fail2ban expect iptraf iperf at uptimed pass wakeonlan ttytter mpg123 yubikey-neo-manager -y
apt-get remove apport -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
echo "action=/sbin/poweroff" > /etc/acpi/events/powerbtn
acpid restart
