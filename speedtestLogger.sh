#!/usr/bin/expect
set outputFile [open /tmp/output.txt w]
exp_internal 1
spawn speedtest-cli
expect "Retrieving speedtest.net configuration..."
expect "Retrieving speedtest.net server list..."
set output $expect_out(buffer)
puts $outputFile "OUTPUT: $output"
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

puts $outputFile "{'fromIpAddress':'$fromIpAddress','hostedBy':'$hostedBy','distance':'$distance','latency':'$latency', 'download': '$download', 'downloadUOM':'$downloadUnit','upload':'$upload','uploadUOM':'$uploadUnit'}"

