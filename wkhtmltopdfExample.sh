#!/bin/bash
#
# wkhtmltopdf example
#
recipients="patrick.archibald@gmail.com"
outputFile="/tmp/output.pdf"
url="https://en.wikipedia.org/wiki/Portal:Arts"
/usr/local/bin/wkhtmltopdf "$url" "$outputFile"
subject="wkhtmltopdf example - $(date) - $0"
body="Scraped $url"
echo "$body" | mail -s "$subject" "$recipients" -A "$outputFile"
