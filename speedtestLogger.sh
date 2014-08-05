#!/bin/bash
#
# Call Expect script and executes the output.
#
OUTPUT_SCRIPT_FROM_EXPECT="/tmp/speedtestLoggerOutput.sh"
rm --force "$OUTPUT_SCRIPT_FROM_EXPECT"
RUNNING_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$RUNNING_DIRECTORY/speedtestLogger.exp
/bin/bash "$OUTPUT_SCRIPT_FROM_EXPECT"
