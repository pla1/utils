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
echo "Filter: $filter"
unset -v latestFile
for file in $filter
do
  [[ $file -nt $latestFile ]] && latestFile=$file
done
echo "Latest file: \"$latestFile\""
if [[ ! -f $latestFile ]]
then
  echo "File not found. Will create initial file."
  cp "$temporaryFile" "$newFile"
  exit 0
fi
cp "$latestFile" "/tmp/."
latestFileBaseName=$(basename "$latestFile")
echo "Comparing files /tmp/$latestFileBaseName to $temporaryFile"
/usr/bin/diff "/tmp/$latestFileBaseName" "$temporaryFile" > "$diffFile"
if [[ -s $diffFile ]]
then
  echo -e "Begin contents of diff file $diffFile on following line(s)."
  cat "$diffFile"
  echo -e "End contents of diff file $diffFile."
  cp "$diffFile" "$newDiffFile"
  cp "$temporaryFile" "$newFile"
  echo "Differences found between $latestFile and $temporaryFile Created new diff file: $newDiffFile"
else
  echo "No differences found between $latestFile and $temporaryFile"
fi
