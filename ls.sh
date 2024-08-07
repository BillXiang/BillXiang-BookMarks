#!/usr/bin/bash
#for file in ./*; do
#    if [ -f "$file" ]; then
#        echo "$file"
#    fi
#done
echo "<!DOCTYPE html> 
  <html> 
    <head>
      <script>
        var _hmt = _hmt || [];
        (function() {
          var hm = document.createElement('"script"');
          hm.src = '"https://hm.baidu.com/hm.js?ec59a7c509d311b9e44b32db0e8bc394"';
          var s = document.getElementsByTagName('"script"')[0]; 
          s.parentNode.insertBefore(hm, s);
        })();
      </script>
    </head>
    <body>
      <table id="myTable">
        <thead><tr><th>Index</th></tr></thead>
        <tbody>" > index.html
        
find . -type f -print0|xargs -0 -i echo {}|cut -d'/' -f2-|grep -v ".git"|grep -v ls.sh|grep -v index.html|
awk -F'(' '{url=$0;sub(/书签工具栏/, "", $0); print $NF,"<tr><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/"url"\">"$0"</a></td></tr>"}'|
sort -rk1|
awk -F'<tr><td>' '{$1=""; print "<tr><td>"$0}'
>> index.html

echo "  </tbody>
      </table>
    </body>
  </html>" >> index.html
