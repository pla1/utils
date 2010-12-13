#!/bin/sh
# Blog post: http://platechnotes.patrickarchibald.com/2010/09/watch-folder-and-upload-new-files-to.html
# 1. Watch ~/PicasaWeb folder. 
# 2. Upload new file to Picasa using Google CLI. 
# 3. Launch the browser to the direct Picasa URL. 
# 
WATCHED_DIR=~/PicasaWeb
googleVersion=$(google --version)
echo $googleVersion
while [ 1 ]
do
  echo 'Watching directory: '$WATCHED_DIR 'for new files'
  while file=$(inotifywait -q -e create "$WATCHED_DIR" --format "%f")
  do
    echo 'New file to upload to PicasaWeb:' $file
    notify-send -i "gtk-go-up" "Picasa Web Monitor" "Uploading image $file"
    mythtvosd --template=alert --alert_text="Uploading image $file"
    google picasa post --title "Drop Box" "$WATCHED_DIR/$file"
    if [ "$googleVersion" = "google 0.9.5" ]; then
     url=$(google picasa list url-direct --title "Drop Box" | grep "$file" | sed -e "s/$file\,//g")
    else 
     url=$(google picasa list --fields url-direct --title "Drop Box" | grep "$file" | sed -e "s/$file\,//g")
    fi
    echo 'Picasa url: ' $url
    notify-send -i "gtk-home" "Picasa Web Monitor" "Image uploaded. Starting Gwibber widget."
    mythtvosd --template=alert --alert_text="Image uploaded. Starting Gwibber widget."
    python ~/Ubuntu\ One/scripts/gwibber-widget.py $url
  done
done

