#!/bin/bash
#
# Renew Let's Encrypt certificate.
#
/usr/bin/curl -vs https://30passwords.com 2>&1 | grep 'expire date:'
cd /home/htplainf/letsencrypt
sudo -su htplainf git pull
./letsencrypt-auto certonly --apache --renew-by-default -d 30passwords.com -d www.30passwords.com
/usr/sbin/service apache2 reload
/usr/bin/curl curl -vs https://30passwords.com 2>&1 | grep 'expire date:'
