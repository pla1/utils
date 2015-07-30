#!/usr/bin/python
import sys
import os
import pyvona
import datetime
import logging
from subprocess import call

def agi_command(cmd):
  print cmd
  sys.stdout.flush()
  response=sys.stdin.readline().strip()
  logging.info(response)
  return response

logging.basicConfig(filename='/tmp/agi.log', filemode='w', level=logging.INFO)

while True:
  line = sys.stdin.readline().strip()
  if not len(line):
    break
  logging.info(line)

with open("/etc/aws.properties") as f:
    keys = f.readlines()
AWS_ACCESS_KEY = keys[0].strip('\n')
AWS_SECRET_KEY = keys[1].strip('\n')
voice = pyvona.create_voice(AWS_ACCESS_KEY, AWS_SECRET_KEY)
#print(v.list_voices())
voice.voice_name = "Salli"
voice.speech_rate = 'fast'
voice.codec = 'mp3'
text=sys.argv[1]
fileName=sys.argv[2]
escapeDigits=sys.argv[3]
directory="/tmp/"
voice.fetch_voice(text,directory+fileName)
sourceFile=directory+fileName
destinationFile=directory+"new"+os.path.splitext(fileName)[0]+".wav"
return_code = call(["/usr/bin/avconv","-loglevel","quiet","-y","-i",sourceFile,"-ar","8000","-ac","1","-ab","64",destinationFile])
agi_command("STREAM FILE "+os.path.splitext(destinationFile)[0]+" \""+escapeDigits+"\"")
