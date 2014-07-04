#!/bin/bash
#
# Touches GWT nocache.js files in the Tomcat web app directory to preven caching.
# Execute this script every minute in a root cron job.
#
cd /var/lib/tomcat7/webapps
find . -name '*nocache.js' | while read file; do
    logger "Touching file '$file'"
    touch "$file"
done
