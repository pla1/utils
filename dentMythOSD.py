#!/usr/bin/python
# Dents to MythTV OnScreen Display (OSD)
#  
#
#

import feedparser
import textwrap
import unicodedata
import commands 
import MySQLdb
import time 
import urllib
import sys 

def normalizeUnicode(string):
	string = string.replace("'","\"")
	return unicodedata.normalize('NFKD', string).encode('ascii', 'ignore')
def doEntry(entry):
	title = normalizeUnicode(entry.title)
	write2DB(title)
def write2DB(msg): 
	cursor = conn.cursor()
	cursor.execute("""Select id from dents where msg = %s""",msg)
	row = cursor.fetchone()
	if row == None:
		print("Not in dents table:" + msg)
		cursor.execute("""insert into dents (msg, logtime) values(%s,current_timestamp())""",msg)
		cursor.execute("""insert into dents (msg, logtime) values('test',current_timestamp())""")
                command = "mythutil --message --timeout 3 --bcastaddr 0.0.0.0  --message_text '" + msg + "'" 
		print command
		commands.getstatusoutput(command)
		time.sleep(4)
	conn.commit()
	cursor.close()	
	
USER = "username"
PASSWORD = "password"
HASHTAG = sys.argv[1]
#TWITTER_URL = "https://" + USER + ":" + PASSWORD + "@twitter.com/statuses/friends_timeline/15456578.rss"
TWITTER_URL = "http://search.twitter.com/search.atom?q="+HASHTAG

#IDENTICA_URL = "http://identi.ca/api/statuses/friends_timeline/" + USER + ".rss"
IDENTICA_URL = "http://identi.ca/search/notice/rss?q="+HASHTAG
SQL_CREATE_TABLE = "create table dents ( id mediumint not null auto_increment, msg text, logtime datetime,  primary key(id));"
#SQL_CREATE_TABLE = "create table dents ( id mediumint not null auto_increment, msg char(200) not null, logtime datetime not null,  primary key(id));"
SQL_DROP_TABLE = "drop table if exists dents"

conn = MySQLdb.connect("localhost","USERNAME","PASSWORD","DATABASENAME")
cursor = conn.cursor()
cursor.execute(SQL_DROP_TABLE)
cursor.execute(SQL_CREATE_TABLE)
conn.commit()
cursor.close()
while (True):
	twitterFeed = feedparser.parse(TWITTER_URL);
	identicaFeed = feedparser.parse(IDENTICA_URL);
	twitterEntries = twitterFeed.entries
	identicaEntries = identicaFeed.entries
	print (str(len(identicaEntries)) + " dents " + str(len(twitterEntries)) + " tweets")
	i = 0
	while (i < len(identicaEntries)):
	    entry = identicaEntries[i]
	    doEntry(entry)
	    i = i + 1
	i = 0
	while (i < len(twitterEntries)):
	    entry = twitterEntries[i]
	    doEntry(entry)
	    i = i + 1
	print("Sleeping")
	time.sleep(60)
	print("Awake")

