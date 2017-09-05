#!/bin/bash
#
# Renew Let's Encrypt certificate.
#
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

/usr/bin/curl -vs https://30passwords.com 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://pla1.info 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://ip.pla1.info 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://canyoureadmymind.com 2>&1 | grep 'expire date:'
cd /home/htplainf/letsencrypt
/home/htplainf/letsencrypt/letsencrypt-auto --verbose certonly --apache --renew-by-default -d 30passwords.com -d www.30passwords.com
/home/htplainf/letsencrypt/letsencrypt-auto --verbose certonly --apache --renew-by-default -d pla1.info
/home/htplainf/letsencrypt/letsencrypt-auto --verbose certonly --apache --renew-by-default -d ip.pla1.net
/home/htplainf/letsencrypt/letsencrypt-auto --verbose certonly --apache --renew-by-default -d canyoureadmymind.com -d www.canyoureadmymind.com
/usr/sbin/service apache2 reload
/usr/bin/curl curl -vs https://30passwords.com 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://pla1.net 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://ip.pla1.net 2>&1 | grep 'expire date:'
/usr/bin/curl -vs https://canyoureadmymind.com 2>&1 | grep 'expire date:'
