#!/bin/bash
#
# Create systemd network files for an interface and VLAN.
#
interface="$1"
vlan="$2"
echo -e "[NetDev]\nName=$interface.$vlan\nKind=vlan\n\n[VLAN]\nId=$vlan" > "/tmp/$interface.$vlan.netdev"
echo -e "[Match]\nName=$interface.$vlan\n\n[Network]\nDHCP=yes" > "/tmp/$interface.$vlan.network"
