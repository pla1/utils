#!/bin/bash
#
# wkhtmltopdf example
#
recipients="patrick.archibald@gmail.com"
outputFile="/tmp/output.pdf"
/usr/local/bin/wkhtmltopdf "https://en.wikipedia.org/wiki/Portal:Arts" "$outputFile"
subject="wkhtmltopdf example - $(date) - $0"
body="Scraped https://en.wikipedia.org/wiki/Main_Page"
echo "$body" | mail -s "$subject" "$recipients" -A "$outputFile"
