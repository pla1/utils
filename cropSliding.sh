#/bin/bash
files="*.JPG"
Y=0
for file in $files
do
  echo "$file"
  echo "Y = $((Y++))"
  mogrify -crop 4000x2250+0+$Y "$file"
done

