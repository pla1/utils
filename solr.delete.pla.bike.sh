#!/bin/bash
#
# Delete all documents in SOLR core bike
#
/opt/solr-7.6.0/bin/post -c bike -type text/xml -out yes -d $'<delete><query>*:*</query></delete>'
