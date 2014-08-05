#!/usr/bin/expect
#
# Parse output from Linux command line speed test speedtest-cli and upload to database table.
#
# This script lives here: https://github.com/pla1/utils/blob/master/speedtestLogger.sh
#
# speedtest-cli lives here: https://github.com/sivel/speedtest-cli
#
# Requires expect. sudo apt-get install expect
#
set outputFile [open /tmp/output.txt w]
exp_internal 1
spawn speedtest-cli
expect "Retrieving speedtest.net configuration..."
expect "Retrieving speedtest.net server list..."
expect -re ".*Testing from .*\\((\[0-9\]{1,3}\.\[0-9\]{1,3}\.\[0-9\]{1,3}\.\[0-9\]{1,3})\\).*" {
	 set fromIpAddress $expect_out(1,string)
}
expect -re ".*Hosted by (.*) \\\[(.*)\\\]: (.*)\r\n.*"  {
	set hostedBy $expect_out(1,string)
	set distance $expect_out(2,string)
	set latency $expect_out(3,string)
}
set timeout 30
expect -re ".*Download: (\[0-9\]+\.\[0-9\]+) (.*)\r\n.*" {
	set download $expect_out(1,string)
	set downloadUnit $expect_out(2,string)
}
expect -re ".*Upload: (\[0-9\]+\.\[0-9\]+) (.*)\r\n.*" {
	set upload $expect_out(1,string)
	set uploadUnit $expect_out(2,string)
}
puts $outputFile "curl --verbose --include --header Content-Type:application/json --header token:6bbc6fe7-5473-4d04-9468-900755 --request PUT --data '{\"download\":$download,\"upload\":$upload}' https://e.hometelco.com/a/SpeedtestUpload"
exec /bin/bash /tmp/output.txt

