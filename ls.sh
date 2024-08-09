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
        
find . -type f -print0|xargs -0 -i echo {}|cut -d'/' -f2-|grep -v ".git"|grep -v ls.sh|grep -v index.html|grep -v README.md|
awk -F'(' '{url=$0;sub(/书签工具栏/, "", $0); print $NF,"<tr><td>"url,"<tr><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/"url"\">"$0"</a></td></tr>"}'|
sort -rk1 > sort.tmp
head -n 3 ./* > head.tmp
cat head.tmp
cat sort.tmp |
awk -F'<tr><td>' '{$1="";file[NR]=$2;$2="";FILENAME=file[NR];cmd = "head -n 3 " FILENAME " | tail -n 1 |cut -c6- > head.tmp" NR;result=system(cmd);}{ret=getline line < ("head.tmp" NR);print "<tr><td><a href=" line ">" result,FILENAME "原文</a></td><td>"$0}{cmd = "cat head.tmp" NR;system(cmd);}' >> index.html
rm -f sort.tmp

echo "  </tbody>
      </table>
    </body>
  </html>" >> index.html
