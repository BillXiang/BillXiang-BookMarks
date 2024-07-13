#!/usr/bin/bash
#for file in ./*; do
#    if [ -f "$file" ]; then
#        echo "$file"
#    fi
#done
echo "<!DOCTYPE html> 
  <html> 
    <head>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.2/jquery.tablesorter.min.js"></script>
    </head>
    <body>
      <table id="myTable" class="tablesorter">
        <thead><tr><th>Index</th></tr></thead>
        <tbody>
          <tr>
            <td>" > index.html
        
find . -type f -print0|xargs -0 -i echo {}|cut -d'/' -f2-|grep -v ".git"|grep -v ls.sh|awk '{url=$0;sub(/书签工具栏/, "", $0);print "<a href=\"https://billxiang.github.io/BillXiang-BookMarks/"url"\">"$0"</a>"}' >> index.html

echo "      </td>
          <tr>
        </tbody>
      </table>
    </body>
  </html>" >> index.html
