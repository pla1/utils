#!/bin/bash
#
# Crawl https://pla.bike
#
logger "$0 Started"
SECONDS=0
/opt/solr-7.6.0/bin/post -c bike -type text/xml -out yes -d $'<delete><query>*:*</query></delete>'
/usr/bin/wget https://pla.bike/sitemap.xml -O /tmp/plabikesitemap.xml
urls="$(/usr/bin/xpath  -q -e '//loc/text()' /tmp/plabikesitemap.xml)"
for url in $urls
do
	if [[ "$url" =~ .*/[0-9]{8}/ ]]
	then
		echo "$url"
		/opt/solr-7.6.0/bin/post -c bike -filestypes html "$url" -delay 1 -recursive 0
	fi
done
logger "$0 Finished in $SECONDS seconds."
