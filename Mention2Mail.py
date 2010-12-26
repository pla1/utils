#! /usr/bin/python
#
# Email new Twitter mentions.
# Prerequisites: Mysql, Tweepy.
# Register this app here: http://twitter.com/apps/new
# Replaces the asterisks with your values.
# Version 2.1 December 26, 2010 - PLA - Add screen name to email subject and body.
# Version 2.0 November 20, 2010
#
#

import time
import datetime

import MySQLdb
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
import smtplib
import tweepy

def sendMail(subject, text):
  gmailUser = '********************@gmail.com'
  gmailPassword = '********************'
  recipient = '*********************@gmail.com'
  msg = MIMEMultipart()
  msg['From'] = gmailUser
  msg['To'] = recipient
  msg['Subject'] = subject
  msg.attach(MIMEText(text))
  mailServer = smtplib.SMTP('smtp.gmail.com', 587)
  mailServer.ehlo()
  mailServer.starttls()
  mailServer.ehlo()
  mailServer.login(gmailUser, gmailPassword)
  mailServer.sendmail(gmailUser, recipient, msg.as_string())
  mailServer.close()
  print('Sent email to %s' % recipient)
def oauthRoutine():
  auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
  auth_url = auth.get_authorization_url()
  print 'Please authorize: ' + auth_url
  verifier = raw_input('PIN: ').strip()
  auth.get_access_token(verifier)
  cursor = conn.cursor()
  sql = "insert into oauth (oauthkey, oauthsecret, logtime) values('%s', '%s', current_timestamp())" % (auth.access_token.key, auth.access_token.secret)
  cursor.execute(sql)
  cursor.close()
  global oauthKey
  global oauthSecret
  oauthKey = auth.access_token.key
  oauthSecret = auth.access_token.secret
def readOauth():
  cursor = conn.cursor()
  cursor.execute("Select oauthkey, oauthsecret from oauth")
  row = cursor.fetchone()
  if row == None:
    print("oAuth key and secret not found in database table. Will get them now.")
    oauthRoutine()
    return
  global oauthKey
  global oauthSecret
  oauthKey = row[0]
  oauthSecret = row[1]
  cursor.close()
def createDatabaseTables():
  SQL_CREATE_MENTIONS_TABLE = "create table if not exists mentions ( id mediumint not null auto_increment, msg char(200) not null, logtime datetime not null,  primary key(id));"
  SQL_CREATE_OAUTH_TABLE = "create table if not exists oauth ( oauthkey varchar(100) not null, oauthsecret varchar(100) not null, logtime datetime not null,  primary key(oauthkey, oauthsecret));"
  cursor = conn.cursor()
  cursor.execute(SQL_CREATE_MENTIONS_TABLE)
  cursor.execute(SQL_CREATE_OAUTH_TABLE)
  cursor.close()
def write2DB(status):
  msg = status.text.replace("'", "\"")
  msg = msg.encode('utf-8')
  cursor = conn.cursor()
  cursor.execute("""Select id from mentions where msg = %s""", msg)
  row = cursor.fetchone()
  if row == None:
    print(msg)
    cursor.execute("""insert into mentions (msg, logtime) value(%s,current_timestamp())""", msg)
    subject = "Twitter mention by " + status.author.screen_name  + ": " + msg
    sendMail(subject, subject + " http://twitter.com/replies");
  cursor.close()
CONSUMER_KEY = '**************************'
CONSUMER_SECRET = '***********************************'
conn = MySQLdb.connect (host="localhost", user="**********************", passwd="********************", db="****************")
createDatabaseTables();
readOauth()
auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(oauthKey, oauthSecret)
api = tweepy.API(auth)
while (True):
  list = api.mentions()
  for status in list:
    write2DB(status)
  print("Sleeping " +  str(datetime.datetime.now()))
  time.sleep(60 * 10)
  print("Awake")
