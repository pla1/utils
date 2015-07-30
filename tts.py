#!/usr/bin/python
#
# Translates text to voice using Ivona.com service.
# This should be called from an Asterisk dialplan.
# Example:
# [incoming]
# exten => 8438431234567,1,Answer()
#  same => n,agi(tts.py,"This text will be translated to voice by Ivona.com.","2")
#  same => n,Hangup()
#
import sys,os,pyvona,datetime,logging,hashlib
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
text=sys.argv[1]
escapeDigits=sys.argv[2]
rate = 'medium'
if len(sys.argv) == 4:
  rate=sys.argv[3]
md5=hashlib.md5()
md5.update(rate)
md5.update(text);
fileName=md5.hexdigest()+".mp3"
directory="/tmp/"
sourceFile=directory+fileName
destinationFile=directory+"new"+os.path.splitext(fileName)[0]+".wav"
if os.path.exists(destinationFile):
    agi_command("STREAM FILE "+os.path.splitext(destinationFile)[0]+" \""+escapeDigits+"\"")
    sys.exit()
with open("/etc/aws.properties") as f:
    keys = f.readlines()
AWS_ACCESS_KEY = keys[0].strip('\n')
AWS_SECRET_KEY = keys[1].strip('\n')
voice = pyvona.create_voice(AWS_ACCESS_KEY, AWS_SECRET_KEY)
#print(v.list_voices())
voice.voice_name = "Salli"
voice.speech_rate = rate
voice.codec = 'mp3'
voice.fetch_voice(text,directory+fileName)
return_code = call(["/usr/bin/avconv","-loglevel","quiet","-y","-i",sourceFile,"-ar","8000","-ac","1","-ab","64",destinationFile])
agi_command("STREAM FILE "+os.path.splitext(destinationFile)[0]+" \""+escapeDigits+"\"")
sys.exit()
