#!/bin/bash
#
# Crawl https://pla.bike
#
/usr/bin/wget https://pla.bike/sitemap.xml -O /tmp/plabikesitemap.xml
urls="$(/usr/bin/xpath  -q -e '//loc/text()' /tmp/plabikesitemap.xml)"
for url in $urls
do
	/opt/solr-7.6.0/bin/post -c bike -filestypes html https://pla.bike/posts/20201107/
done
