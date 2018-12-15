#!/bin/bash
#
# Inspect Apache log for host names containing 1337x. Add to UFW if not already denied in UFW.
#
logger "$0 Started"
/usr/sbin/ufw status | grep DENY > /tmp/ufw.txt
grep 1337x /var/log/apache2/access.log | cut -d ' ' -f1 > /tmp/ipAddresses.txt
rm -r /tmp/ufw_script.sh
touch /tmp/ufw_script.sh
while read -r line
do
  found=$(grep "$line" /tmp/ufw.txt)
  if [ -z "$found" ]
  then
    found=$(grep "$line" /tmp/ufw_script.sh)
    if [ -z "$found" ]
    then
      logger "$0 Adding $line to script /tmp/ufw_script.sh regarding 1337x hosts."
      echo "/usr/sbin/ufw insert 1 deny from $line to any" >> /tmp/ufw_script.sh
    fi
  fi
done < /tmp/ipAddresses.txt
if [ ! -s /tmp/ufw_script.sh ]
then
  logger "$0 No IP addresses added to UFW regarding 1337x hosts."
  exit 0
fi
/bin/sh /tmp/ufw_script.sh
cat /tmp/ufw_script.sh | /usr/bin/mail -s "UFW updated $(date) $(hostname) $0" patrick.archibald@gmail.com
logger "$0 Finished"
