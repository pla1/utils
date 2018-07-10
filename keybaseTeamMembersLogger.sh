#!/bin/bash
#
# Track memberships for a team.
#
function log() {
  logger "$0 $1"
  echo "$0 $1"
}
if [ "$#" -ne 1 ]; then
  log "Pass a team name. Example: ./keybaseTeamMembers.sh chstech"
  exit -1
fi
team="$1"
if [ ! -d "/keybase/team/$team" ]
then
  log "Team directory /keybase/team/$team not found"
  exit -1
fi
temporaryFile="/tmp/keybase_members.txt"
diffFile="/tmp/keybase_members_diff.txt"
yyyymmdd=$(date +%Y%m%d)
log "Date: $yyyymmdd"
newFile="/keybase/team/$team/$team"
newFile+="_members_"
newDiffFile="$newFile"
newDiffFile+="diff_"
newFile+="$yyyymmdd"
newDiffFile+="$yyyymmdd"
newDiffFile+=".txt"
newFile+=".txt"
/usr/bin/keybase team list-members "$team" | sort > "$temporaryFile"
filter="/keybase/team/$team/$team"
filter+="_members_*.txt"
log "Filter: $filter"
unset -v latestFile
for file in $filter
do
  [[ $file -nt $latestFile ]] && latestFile=$file
done
log "Latest file: \"$latestFile\""
if [[ ! -f $latestFile ]]
then
  log "File not found. Will create initial file."
  cp "$temporaryFile" "$newFile"
  exit 0
fi
cp "$latestFile" "/tmp/."
latestFileBaseName=$(basename "$latestFile")
log "Comparing files /tmp/$latestFileBaseName to $temporaryFile"
/usr/bin/diff "/tmp/$latestFileBaseName" "$temporaryFile" > "$diffFile"
if [[ -s $diffFile ]]
then
  log -e "Begin contents of diff file $diffFile on following line(s)."
  cat "$diffFile"
  log -e "End contents of diff file $diffFile."
  cp "$diffFile" "$newDiffFile"
  cp "$temporaryFile" "$newFile"
  log "Differences found between $latestFile and $temporaryFile Created new diff file: $newDiffFile"
else
  log "No differences found between $latestFile and $temporaryFile"
fi
