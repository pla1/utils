#!/usr/bin/expect
#exp_internal 1
set timeout 120
set CLIENT_ID "142445980798-qcuj2ujq3ri1g8q1adgh270ph7v36t0f.apps.googleusercontent.com"
set CLIENT_SECRET "1F1_1_gKkgiNMypuXGp4wnVI"
set SCOPES "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/plus.me"
#set SCOPES "https://www.googleapis.com/auth/plus.me"
set accessToken ""
if { [file exists /tmp/googlePlusAccessToken.txt] } {
  set fp [open /tmp/googlePlusAccessToken.txt r]
  set accessToken [read $fp]
  puts "Got access token from file. Token: $accessToken"
  close $fp
}
set accessTokenLength [string length $accessToken]
puts "Access token length $accessTokenLength"
if { [string length $accessToken] == 0 } {
  spawn curl -d "client_id=$CLIENT_ID&scope=$SCOPES" https://accounts.google.com/o/oauth2/device/code 
  expect { 
    -re ".*\"device_code\" : \"(.*)\",\r\n  \"user_code\" : \"(\[a-z0-9\]+)\",\r\n  \"verification_url\" : \"(.*)\",.*" {
      set deviceCode $expect_out(1,string)
      set userCode $expect_out(2,string)
      set verificationUrl $expect_out(3,string)
      puts "\n\n\n\n"
      puts "User code is: $userCode"
      puts "Device code is: $deviceCode"
      puts "Verfication URL is: $verificationUrl"
    }
    -re "\"error\" :" {
      puts "Error. Exiting."
      exit
    }
  }

  puts "Press enter to open your browser, key the code: $userCode into the browser form and then return back here."
  expect_user -re "(.*)\n"
  exec /usr/bin/google-chrome $verificationUrl & 
  puts "Press enter after you have finished in the browser."
  expect_user -re "(.*)\n"

  spawn curl -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$deviceCode&grant_type=http://oauth.net/grant_type/device/1.0" https://accounts.google.com/o/oauth2/token
  expect -re ".*\"access_token\" : \"(.*)\",\r\n  \"token_type\" :" {
    set accessToken $expect_out(1,string)
    puts "\n\n\n\n"
    puts "Access token is: $accessToken"
    set outputFile [open /tmp/googlePlusAccessToken.txt w]
    puts $outputFile $accessToken
    close $outputFile
  }
}
spawn curl -H "Authorization: Bearer $accessToken" https://www.googleapis.com/plus/v1/people/me
expect -re "isPlusUser" {
 
}




spawn curl -H "Authorization: Bearer $accessToken" https://www.googleapis.com/plus/v1/people/me/people/visible
expect -re "isPlusUser" {
 
}



