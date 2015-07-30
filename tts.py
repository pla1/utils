#!/usr/bin/python
#
# Translates text to voice using Ivona.com service.
# This should be called from an Asterisk dialplan.
# Example:
# [incoming]
# exten => 8438431234567,1,Answer()
#  same => n,agi(tts.py,This text will be translated to voice by Ivona.com.,1234567890,fast)
#  same => n,Hangup()
#
import sys,os,pyvona,datetime,logging,hashlib,re
from subprocess import call

def log(message):
    logging.info(datetime.datetime.now().strftime("%I:%M:%S%p on %B %d, %Y") + " " + message)

def agi_command(cmd):
    log("agi_command method command: " + cmd)
    print cmd
    sys.stdout.flush()
    return sys.stdin.readline().strip()

def stream_file(fileName, escapeDigits):
    log("stream_file method with file: " + fileName + " and escapeDigits: " + escapeDigits)
    cmd = "STREAM FILE "
    cmd += os.path.splitext(destinationFile)[0]
    cmd += " "
    if len(escapeDigits) == 0:
        cmd += '""'
    else:
        cmd += escapeDigits
    response = agi_command(cmd)
    log("Response after STREAM FILE is: " + response)
    m = re.match("200 result=(-?\d+) .*",response)
    if m:
        log("Matched the regular expression. The value is: '" + m.group(1) + "'")
        digit = chr(int(m.group(1)))
        if digit > 0:
            log("Got digit: " + digit);
            agi_command("SET VARIABLE responseDigit " + digit)
        else:
            log("Did not get digit. Not > -1")
    else:
        log("Result did not match regular expression")
    return response

text=sys.argv[1]
rate = "medium"
if len(sys.argv) == 4:
    rate=sys.argv[3]
    log("Rate is:"+rate)
md5=hashlib.md5()
md5.update(rate)
md5.update(text);
logging.basicConfig(filename='/tmp/'+md5.hexdigest()+'.log', filemode='w', level=logging.INFO)

while True:
    line = sys.stdin.readline().strip()
    if len(line) == 0:
        log("End of standard input at startup.")
        break
    log("Standard input at startup: "+line)
escapeDigits=""
if len(sys.argv) > 2:
    escapeDigits=sys.argv[2]
    log("Escape digits are:"+escapeDigits)
fileName=md5.hexdigest()+".mp3"
directory="/tmp/"
sourceFile=directory+fileName
destinationFile=directory+"new"+os.path.splitext(fileName)[0]+".wav"
log("Checking existance of file: " + destinationFile)
if os.path.exists(destinationFile):
    log("Recording already exists. Using it " + destinationFile)
    stream_file(destinationFile, escapeDigits)
    log("Exiting script")
else:
    log("Recording does not exist. Contacting Ivona.com to create it. " + destinationFile)
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
    stream_file(destinationFile, escapeDigits)
log("Exiting")
sys.exit()
