/*
Kodi DJ - Announces the song title and artist at the beginning of each song.

Uses: NodeJS, WebSockets, and Asterisk Google TTS.

WebSockets: npm install ws
Asterisk Google TTS: git clone git://github.com/zaf/asterisk-googletts

*/
var WebSocket = require('ws')

function openWebSocket() {
  console.log("Attempt opening WebSocket.");
  var ws = new WebSocket("ws://localhost:9090");

  ws.onerror = function(err) {
    console.log("ERROR: " + err);
    setTimeout(openWebSocket, 1000);
  }
  ws.onopen = function() {
    console.log("Connection is open");
  };

  ws.onmessage = function (message) {
    var jsonObject = JSON.parse(message.data);
    console.log("Message received start: ");
    console.dir(jsonObject);
    console.log("Message received end.");
    if (jsonObject.hasOwnProperty("result")) {
      var result = jsonObject.result;
      if (result.hasOwnProperty("songdetails")) {
        var title = jsonObject.result.songdetails.title;
        var artist = jsonObject.result.songdetails.artist[0];
        console.log("Artist: " + artist + " title: " + title);
        var text = "Now playing, " + title + " by " + artist;
        console.log(text);
        var command = '~/asterisk-googletts/cli/googletts-cli.pl -t "' + text + '"';
        var exec = require('child_process').exec,child;
        child = exec(command,
          function (error, stdout, stderr) {
            console.log('stdout: ' + stdout);
            console.log('stderr: ' + stderr);
            if (error !== null) {
              console.log('exec error: ' + error);
            }
          });
        }
      }
      var method = "";
      if (jsonObject.hasOwnProperty("method")) {
        method = jsonObject.method;
      }
      if (method == "Player.OnPlay") {
        console.log("Method: Player.OnPlay type:" + jsonObject.params.data.item.type);
        if (jsonObject.params.data.item.type == "song") {
          var id = jsonObject.params.data.item.id;
          var data = {
            jsonrpc : "2.0",
            method : "AudioLibrary.GetSongDetails",
            id : 1,
            params : {
              songid : id,
              properties: ["title", "album", "artist", "duration", "thumbnail", "file", "fanart"]
            }
          }
          console.log("Sending " + JSON.stringify(data));
          ws.send(JSON.stringify(data));
        }
      }
    };

    ws.onclose = function() {
      console.log("Connection is closed...");
    };
  }
  openWebSocket();
