#!/usr/bin/bash
#for file in ./*; do
#    if [ -f "$file" ]; then
#        echo "$file"
#    fi
#done
echo "<!DOCTYPE html> 
<html> 
  <head>
  </head>
  <body>
    <h1>Index</h1>
    <hr><pre>" > index.html
find . -type f -print0|xargs -0 -i echo {}|cut -d'/' -f2-|grep -v ".git"|grep -v ls.sh|awk '{print "<a href=\"https://billxiang.github.io/BillXiang-BookMarks/"$0"\"></a>"}' >> index.html
echo "</pre><hr>
  </body></html>" >> index.html
