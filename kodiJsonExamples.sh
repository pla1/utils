#!/bin/bash
#
# Kodi JSON examples.
#
#
cr=$'\n\n'
hostname="i3c.pla.lcl"
port=8080
user=""
password=""

read -p "$cr Press ENTER to clear playlist 1"

curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Playlist.Clear","params":{"playlistid":1},"id":1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to add a YouTube video to playlist 1"

curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Playlist.Add","params":{"playlistid":1,"item": {"file":"plugin://plugin.video.youtube/?action=play_video&videoid=tYThqD2pQbI"}},"id":1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to add another YouTube video to playlist 1"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Playlist.Add","params":{"playlistid":1,"item": {"file":"plugin://plugin.video.youtube/?action=play_video&videoid=6yvIkbStKSw"}},"id":1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to play playlist 1"

curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Player.Open","params":{"item": {"playlistid":1}}}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER goto next in playlist 1"

curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Player.GoTo","params":{"playerid":1,"to": "next"},"id":1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to play a single YouTube video"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"Player.Open","params":{"item": {"file":"plugin://plugin.video.youtube/?action=play_video&videoid=Cj6ho1-G6tw"}},"id":1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to toggle mute"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "Application.SetMute", "params": {"mute":"toggle"}, "id": 1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to toggle mute again"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "Application.SetMute", "params": {"mute":"toggle"}, "id": 1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to set the volume to 10"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": {"volume":10}, "id": 1}' "http://$hostname:$port/jsonrpc"

read -p "$cr Press ENTER to set the volume to 30"


curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": {"volume":30}, "id": 1}' "http://$hostname:$port/jsonrpc"


read -p "$cr Press ENTER to stop playback"

curl --user "$user:$password" --header "Content-Type: application/json" --data '{"jsonrpc": "2.0", "method": "Player.Stop", "params": {"playerid":1}, "id": 1}' "http://$hostname:$port/jsonrpc"


