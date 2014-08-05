#!/bin/bash
#
# Call Expect script and executes the output.
#
function log() {
	echo "$1"
	logger "$1"
}
TOKEN=$(cat /etc/speedtestLogger-token)
if [ -z "$TOKEN" ] 
then
	HOSTNAME=$(hostname)
	IP=$(curl http://myip.pla1.net)
	message="Speedtest token missing. Speed test aborted. $HOSTNAME $IP"
	log "$message"
	echo "$message" | mail -s "$message" root
	exit
fi
log "$0 started."
OUTPUT_SCRIPT_FROM_EXPECT="/tmp/speedtestLoggerOutput.sh"
rm --force "$OUTPUT_SCRIPT_FROM_EXPECT"
RUNNING_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$RUNNING_DIRECTORY"/speedtestLogger.exp "$TOKEN"
/bin/bash "$OUTPUT_SCRIPT_FROM_EXPECT"
log "$0 ended."
