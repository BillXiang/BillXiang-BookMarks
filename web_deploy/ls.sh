#!/usr/bin/bash
rm -f *.tmp

html_head="<!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <link rel="stylesheet" href="./web_deploy/gitalk.css">
      <script src="./web_deploy/gitalk.min.js"></script>
      <title>BillXiang</title>
      <link rel="stylesheet" type="text/css" href="./web_deploy/style.css">
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
      <img src="./web_deploy/avatar.jpeg" class="round_icon"  alt="">
      <table id="root">
      <tbody>
      <tr>
        <td valign="top" width="20%">
          <table id="sidebar" style='margin-top: 20px;margin-bottom: 20px;'>
            <tbody>
              <tr><td><a href='./index.html'><b>Recently Read</b></a></td></tr>
              <tr><td><a href='./all.html'><b>All</b></a></td></tr>
              <tr><td><a href='./docs.html'><b>Docs</b></a></td></tr>
              <tr><td>"
              
    html_mid="</td></tr>
            </tbody>
          </table>
        </td>
        <td>
          <table id="myTable">
          <tbody>
      "
        
echo $html_head | tee all.html index.html docs.html

read_dir(){
    for file in "$1"/*;
    do
        if [ -d "$file" ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                read_dir "$file"
            fi
        else
            html=$(echo $file|grep "html$"|wc -l)
            kimi=$(echo $file|grep "kimi$"|wc -l)
            
            name=${file/\.\//}
            name=${name/书签工具栏/}
            name=${name/(*).html/}
            echo $name
            if [[ "$html" -ne 0 ]];then
                ori_url=`head -n 3 "$file"|tail -n 1`
                ori_url=${ori_url:6}

                echo $file | awk -F'[/()]' '{print $(NF-1), $(NF-2)}' | while read a b c
                do
                    echo $a,$b,$c
                    tags=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf $i;if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                    kimi=`cat "${file}.kimi"`
                    cd tags
                    echo "<tr><td><table style='margin-top: 20px;margin-bottom: 20px;width:80%;'><tbody> \
                    <tr><td>${a}_${b}</td></tr> \
                    <tr style='font-size: 25px;'><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\"><b>$c</b></a></td></tr> \
                    <tr><td>$kimi</td></tr> \
                    <tr><td><a href='$ori_url'>原文链接</a> TAGs:$tags</td></tr> \
                    </tbody></table></td></tr>" | tee -a ../url.tmp $tags
                    cd ..
                done
            elif [[ "$kimi" -ne 1 ]];then
                echo "<tr><td></td><td></td><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$name</a></td></tr>" >> docs.tmp
            fi
        fi
    done
    
}

echo "" > url.tmp
echo "" > docs.tmp
mkdir tags
read_dir "."
find ./tags -type f |xargs -i mv {} {}.html
wc -l tags/*|sort -r|tail -n +2|head -n 10|awk -F'[/.[:space:]]' '{print "<a href=./tags/"$(NF-1)".html>"$(NF-1),"</a>"$(NF-3)"篇<br>"}' | tee -a all.html index.html docs.html
wc -l tags/*|sort -r|tail -n +2|awk -F'[/.[:space:]]' '{print "<a href=./tags/"$(NF-1)".html>"$(NF-1),"</a>"$(NF-3)"篇<br>"}' >> all_tags.html
echo "<a href=./all_tags.html>All TAGs</a><br>" | tee -a all.html index.html docs.html
echo $html_mid | tee -a all.html index.html docs.html

cat url.tmp |LC_ALL=C  sort -t'_' -rn -k1 -k2 -k3 -k4 -k5 -k6 |head -n 20 >> index.html
cat url.tmp |LC_ALL=C  sort -t'_' -rn -k1 -k2 -k3 -k4 -k5 -k6 | grep -v "web_deploy" | grep -v index.html  |grep -v all.html |grep -v docs.html>> all.html
cat docs.tmp | grep -v "web_deploy" | grep -v README.md  |grep -v url.tmp |grep -v docs.tmp >> docs.html
rm -f url.tmp

echo "        </tbody>
            </table>
          </td>
        </tr>
        <tr><td><a href='https://github.com/gildas-lormeau/SingleFile'><b>Saved by SingleFile</b></a></td></tr>
        </tbody>
      </table>
      <div id="gitalk-container"></div>
      <script>
      const gitalk = new Gitalk({
        clientID: 'Ov23likAQqUjMmw0YgcJ',
        clientSecret: 'b7c0049ccc92a8478fcd41efb9bcd847b0588f82',
        repo: 'BillXiang-BookMarks',
        owner: 'BillXiang',
        admin: ['BillXiang'],
        id: location.pathname,      // Ensure uniqueness and length less than 50
        distractionFreeMode: false  // Facebook-like distraction free mode
      })
       
      gitalk.render('gitalk-container')
      </script>
    </body>
</html>" >> index.html

echo "        </tbody>
            </table>
          </td>
        </tr>
        <tr><td><a href='https://github.com/gildas-lormeau/SingleFile'><b>Saved by SingleFile</b></a></td></tr>
        </tbody>
      </table>
    </body>
</html>" >> all.html

echo "        </tbody>
            </table>
          </td>
        </tr>
        </tbody>
      </table>
    </body>
</html>" >> docs.html
rm -f *.tmp
