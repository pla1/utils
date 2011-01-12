"""
Check-in to GetGlue. Pass the show title to this python script
and it will use the GetGlue API to check-in. 

Prerequisite: https://github.com/simplegeo/python-oauth2

The first time you run this, run it from a console terminal.
You will need to authorize this
app via the GetGlue website. This app will display a URL
that you will need to access and allow this app access.
After you are done with the web site, press Y to continue.

MythTV users can use the system event "Playback started". 
The syntax for the event should be something like: 

/usr/bin/python /home/htplainf/MythTVGetGlueCheckin4.py '%TITLE%'

Here is my blog entry for more info: 
http://platechnotes.patrickarchibald.com/2010/12/checking-in-at-getglue-with-mythtv.html

"""
import os.path
import sys

import oauth2 as oauth
import re
import urlparse

def log(record):
  f = open(LOG_FILE, 'wa')
  f.write('\n')
  f.write(record)
  f.write('\n')
  f.close()
def /home/htplainf/utils/.git/index.lock():
  showTitle = sys.argv[1]
  showTitle = showTitle.lower()
  showTitle = showTitle.replace(' & ', '_')
  showTitle = showTitle.replace(' ', '_')
  showTitle = showTitle.replace('-', '_')
  showTitle = showTitle.replace(':', '')
  showTitle = re.sub('^the_', '', showTitle)
  showTitle = re.sub('two_and_a_half_men', 'two_half_men', showTitle)
  showTitle = re.sub('kimora_life_in_the_fab_lane', 'kimora_life_in_fab_lane', showTitle)
  showTitle = re.sub('brandy_ray_j_a_family_business', 'brandy_ray_j_family_business', showTitle)
  return showTitle
def oauthRoutine():
  consumer = oauth.Consumer(CONSUMER_KEY, CONSUMER_SECRET)
  client = oauth.Client(consumer)
  resp, content = client.request(REQUEST_TOKEN_URL, "GET")
  if resp['status'] != '200':
    raise Exception("Invalid response %s." % resp['status'])
  request_token = dict(urlparse.parse_qsl(content))
  print "Request Token:"
  print "    - oauth_token        = %s" % request_token['oauth_token']
  print "    - oauth_token_secret = %s" % request_token['oauth_token_secret']
  print
  print "Go to the following link in your browser:"
  print "%s?oauth_token=%s" % (AUTHORIZATION_URL, request_token['oauth_token'])
  print
  accepted = 'n'
  while accepted.lower() == 'n':
    accepted = raw_input('Have you authorized me? (y/n) ')
  token = oauth.Token(request_token['oauth_token'],
                      request_token['oauth_token_secret'])
  client = oauth.Client(consumer, token)
  resp, content = client.request(ACCESS_TOKEN_URL, "POST")
  access_token = dict(urlparse.parse_qsl(content))
  global oauthKey
  global oauthSecret
  oauthKey = access_token['oauth_token']
  oauthSecret = access_token['oauth_token_secret']
  f = open(OAUTH_HOLDER_FILE, 'w')
  f.write(oauthKey)
  f.write('\n')
  f.write(oauthSecret)
  f.write('\n')
  f.close()
def readOauth():
  if os.path.isfile(OAUTH_HOLDER_FILE) != True:
    print("oAuth key and secret not found. Will get them now.")
    oauthRoutine()
    return
  global oauthKey
  global oauthSecret
  f = open(OAUTH_HOLDER_FILE, 'r')
  oauthKey = f.readline().rstrip('\n')
  oauthSecret = f.readline().rstrip('\n')
  f.close()

if (len(sys.argv) == 1):
  print 'Please pass a show title. For example: python ' + sys.argv[0] + ' \"The Closer\"'
  sys.exit(-1)
REQUEST_TOKEN_URL = 'http://api.getglue.com/oauth/request_token'
AUTHORIZATION_URL = 'http://getglue.com/oauth/authorize'
ACCESS_TOKEN_URL = 'http://api.getglue.com/oauth/access_token'
CONSUMER_KEY = 'REQUEST YOUR OWN KEY - EMAIL api@getglue.com'
CONSUMER_SECRET = 'REQUEST YOUR OWN KEY - EMAIL api@getglue.com'
OAUTH_HOLDER_FILE = os.path.expanduser('~') + '/.MythTVGetGlueCheckin'
LOG_FILE = os.path.expanduser('~') + '/MythTVGetGlueCheckin.log'

readOauth()
showTitle = fixupTitle()
consumer = oauth.Consumer(CONSUMER_KEY, CONSUMER_SECRET)
client = oauth.Client(consumer)
token = oauth.Token(oauthKey, oauthSecret)
client = oauth.Client(consumer, token)
#protectedResource = 'http://api.getglue.com/v2/object/get?objectId=tv_shows/' + showTitle
#protectedResource = 'http://api.getglue.com/v2/object/get?objectId=' + sys.argv[1]
protectedResource = 'http://api.getglue.com/v2/user/addCheckin?source=http://www.mythtv.org&app=MythTVCheckin&comment=This show was recorded and viewed using MythTV - A free and open source home entertainment application&objectId=tv_shows/' + showTitle
print protectedResource
resp, content = client.request(protectedResource, 'GET')
print content
log(content)
