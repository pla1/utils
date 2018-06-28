#!/bin/bash
#
# Track memberships for a team.
#
if [ "$#" -ne 1 ]; then
  echo "Pass a team name. Example: ./keybaseTeamMembers.sh chstech"
  exit -1
fi
team="$1"
if [ ! -d "/keybase/team/$team" ]
then
  echo "Team directory /keybase/team/$team not found"
  exit -1
fi
temporaryFile="/tmp/keybase_members.txt"
diffFile="/tmp/keybase_members_diff.txt"
yyyymmdd=$(date +%Y%m%d)
echo "Date: $yyyymmdd"
/usr/bin/keybase team list-members "$team" > "$temporaryFile"
filter="/keybase/team/$team/$team"
filter+="_members_*.txt"
echo "Filter: $filter"
unset -v latestFile
for file in $filter
do
  [[ $file -nt $latestFile ]] && latestFile=$file
done
echo "Latest file: \"$latestFile\""
echo "Comparing files $latestFile to $temporaryFile"
/usr/bin/diff "$latestFile" "$temporaryFile" > "$diffFile"
if [ -s "$diffFile" ]
then
  echo "No differences found between $latestFile and /tmp/keybase_members.txt"
  exit 0
else
  cat "$diffFile"
  newFile="/keybase/team/$team/$team"
  newFile+="_members_"
  newDiffFile="$newFile"
  newDiffFile+="diff_"
  newFile+="$yyyymmdd"
  newDiffFile+="$yyyymmdd"
  newDiffFile+=".txt"
  newFile+=".txt"
  cp "$diffFile" "$newDiffFile"
  cp "$temporaryFile" "$newFile"
  echo "Differences found between $latestFile and /tmp/keybase_members.txt Created new diff file: $newDiffFile"
  exit 0
fi
