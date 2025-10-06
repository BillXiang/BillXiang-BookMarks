#!/usr/bin/bash
rm -f *.tmp

html_head="<!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <link rel="stylesheet" href="./web_deploy/gitalk.css">
      <script src="./web_deploy/gitalk.min.js"></script>
      <link rel="icon" href="./favicon.ico">
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
        function setHeightToContent() {
          var iframe = document.getElementById('content-frame');
          iframe.style.height = iframe.contentWindow.document.documentElement.scrollHeight + 'px';
        };
        window.onload = setHeightToContent;
        function setGithubProxy() {
          var iframe = document.getElementById('content-frame');
          var github_proxy_input = document.getElementById('github-proxy');
          var github_proxy = github_proxy_input.value;
          iframe.contentWindow.postMessage({ github_proxy }, \"*\");
          console.log(github_proxy);
        };
      </script>
    </head>
    <body>
      <img src="./web_deploy/avatar.jpeg" class="round_icon"  alt="me">
      <table id="root-table" width="100%">
      <tbody>
      <tr>
        <td valign="top" width="20%">
          <table id="sidebar" style='margin-top: 20px;margin-bottom: 20px;'>
            <tbody>
              <tr><td><a href='./index.html'><b>Recently Read</b></a></td></tr>
              <tr><td><a href='./all.html'><b>All</b></a></td></tr>
              <tr><td><a href='./docs.html'><b>Docs</b></a></td></tr>
              <tr><td><a href='./tags/Contribute.html'><b>Contributions</b></a></td></tr>
              <tr><td>"
              
    html_mid="</td></tr>
              <tr>
                 <td>
                   <h3><a href=\"https://github.akams.cn/\">Github Proxy:</a></h3>
                   <input id='github-proxy' value=\"https://gh.llkk.cc/\"><br>
                   <button onclick='setGithubProxy()'>Set</button>
                 </td>
              </tr>
              <tr>
                <td>
                  <iframe src=\"https://webchat.oftc.net/?channels=virt&uio=MT11bmRlZmluZWQb1\" width=\"100%\" height=\"400\"></iframe>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
        <td>
      "

read_dir(){
    for file in "$1"/*;
    do
        if [ -d "$file" ]
        then
            if [[ $file != '.' && $file != '..' && $file != './web_deploy' ]]
            then
                echo "read_dir" "$file"
                read_dir "$file"
            fi
        else
            html=$(echo $file|grep "html$"|wc -l)
            pdf=$(echo $file|grep "pdf$"|wc -l)
            md=$(echo $file|grep "md$"|wc -l)
            
            name=${file/\.\//}
            name=${name/书签工具栏/}
            name=${name/(*).html/}
            #echo $name
            if [[ "$html" -ne 0 ]];then
                ori_url=`head -n 3 "$file"|tail -n 1`
                ori_url=${ori_url:6}
                ori_url="${ori_url%"${ori_url##*[![:space:]]}"}"
                summary=`head -n 4 "$file"|tail -n 1`

                echo $file | awk -F'[/()]' '{print $(NF-1), $(NF-2)}' | while read a b c
                do
                    #echo $a,$b,$c
                    tags=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="contribute") {$i="Contribute"}; if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf $i;if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                    tags_url=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="contribute") {$i="Contribute"}; if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf "<a href=./tags/"$i">"$i"</a>";if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                    cd tags
                    echo "<tr><td><table style='margin-top: 20px;margin-bottom: 20px;width:80%;'><tbody> \
                    <tr><td style='display: none;'>_${a}_${b}_</td><td>${a} ${b}</td></tr> \
                    <tr style='font-size: 25px;'><td><a href=\"$ori_url?source=https://billxiang.github.io/BillXiang-BookMarks\" target=\"_blank\"><b>$c</b></a></td></tr> \
                    <tr style='font-size: 15px;'><td><a onclick=\"clickBackup(this)\" href=\"./web_deploy/html_preview.html?rawUrl=https://raw.githubusercontent.com/BillXiang/BillXiang-BookMarks/refs/heads/main/$file\" target=\"_blank\">原文链接失效了?试试备份</a></td></tr> \
                    <tr><td>TAGs:$tags_url</td></tr> \
                    <tr><td>$summary</td></tr> \
                    </tbody></table></td></tr>" | tee -a ../url.tmp $tags
                    cd ..
                done
                echo rm "$file"
                rm "$file"
            elif [[ "$md" -ne 0 ]];then
                file_name=$(echo $file | awk -F'/' '{print $NF}')
                tags=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf $i;if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                tags_url=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf "<a href=./tags/"$i">"$i"</a>";if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                echo "<tr><td><table style='margin-top: 20px;margin-bottom: 20px;width:80%;'><tbody> \
                      <tr><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/web_deploy/markdown_view.html?rawUrl=https://billxiang.github.io/BillXiang-BookMarks/$file\">$file_name</a></td></tr> \
                      </tbody></table></td></tr>" >> docs.tmp
                #echo "<tr style='margin-bottom: 20px;'><td>TAGs:$tags_url</td></tr>" >> docs.tmp
                cat docs.tmp
            elif [[ "$pdf" -ne 0 ]];then
                file_name=$(echo $file | awk -F'/' '{print $NF}')
                echo "###################"
                echo $file
                echo $file | awk -F'[/()]' '{print $(NF-1), $(NF-2)}' | while read a b c
                do
                    echo $a,$b,$c
                    tags=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf $i;if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                    tags_url=$(echo $file|awk -F'[/]' '{for (i=1;i<NF;i++) {if ($i=="书签工具栏"||$i=="study"||$i==".") {$i=""} else {printf "<a href=./tags/"$i">"$i"</a>";if(i!=NF-1){printf " "}else{printf "\n"}}}}')
                    cd tags
                    echo "<tr><td><table style='margin-top: 20px;margin-bottom: 20px;width:80%;'><tbody> \
                        <tr><td style='display: none;'>_${a}_${b}_</td><td>${a} ${b}</td></tr> \
                        <tr style='font-size: 25px;'><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$c</a></td></tr> \
                        <tr><td>TAGs:$tags_url</td></tr> \
                        </tbody></table></td></tr>" | tee -a ../docs.tmp ../url.tmp $tags
                    #cat docs.tmp
                done
            fi
        fi
    done
    
}

echo "" > url.tmp
echo "" > docs.tmp
mkdir tags
read_dir "."
echo $html_head | tee all.html index.html docs.html

find ./tags -type f |xargs -i mv {} {}.html
echo "<hr><h3>TAGs</h3>" | tee -a all.html index.html docs.html
wc -l tags/*|sort -r|tail -n +2|head -n 20|awk -F'[/.[:space:]]' '{print "<a href=./tags/"$(NF-1)".html>"$(NF-1),"</a>"$(NF-3)"篇<br>"}' | tee -a all.html index.html docs.html
wc -l tags/*|sort -r|tail -n +2|awk -F'[/.[:space:]]' '{print "<a href=./tags/"$(NF-1)".html>"$(NF-1),"</a>"$(NF-3)"篇<br>"}' >> all_tags.html
echo "<a href=./all_tags.html>All TAGs</a><br>" | tee -a all.html index.html docs.html
echo $html_mid | tee -a all.html index.html docs.html

########
echo "<!DOCTYPE html>
  <html>
    <head>
      <script>
        var github_proxy;
        function clickBackup(obj) {
          var href = obj.getAttribute(\"href\");
          var new_href = href + \"&github_proxy=\" + github_proxy;
          console.log(new_href);
          obj.setAttribute(\"href\", new_href);
          return true;
        }
        window.addEventListener(\"message\", function(event) {
          github_proxy = event.data.github_proxy;
          console.log(github_proxy);
        });
      </script>
    </head>
    <body>
    <table id="myTable">
          <tbody>" | tee index_content.html all_content.html docs_content.html
awk -F '[：_-]' '{print $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $0}' url.tmp | sort -rn -k1 -k2 -k3 -k4 -k5 -k6 | cut -f7- | head -n 20 >> index_content.html
awk -F '[：_-]' '{print $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $0}' url.tmp | sort -rn -k1 -k2 -k3 -k4 -k5 -k6 | cut -f7- >> all_content.html
echo "**************************"
cat docs.tmp
awk -F '[：_-]' '{print $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $0}' docs.tmp | sort -rn -k1 -k2 -k3 -k4 -k5 -k6 | cut -f7- |grep -v "url.tmp" |grep -v "docs.tmp"|grep -v "favicon.ico"|grep -v "README.md" |tee -a docs_content.html
echo "    </tbody>
      </table>
      </body>" | tee -a index_content.html all_content.html docs_content.html
rm -f url.tmp

echo "<iframe id='content-frame' src='./index_content.html'  frameborder='0' width="100%">Your browser does't support iframe</iframe>" >> index.html
echo "<iframe id='content-frame' src='./all_content.html' frameborder='0' width="100%">Your browser does't support iframe</iframe>" >> all.html
echo "<iframe id='content-frame' src='./docs_content.html' frameborder='0' width="100%">Your browser does't support iframe</iframe>" >> docs.html

echo " 
          </td>
        </tr>
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/webpage-saver'><b>Saved by X-Webpage-Conserve</b></a></td></tr>
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/orbit-summarizer'><b>Summarized by Mozilla Orbit AI</b></a></td></tr>
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/immersive-translate'><b>Translated by 【沉浸式翻译】</b></a></td></tr>
        </tbody>
      </table>
      <div id='gitalk-container'></div>
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
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/webpage-saver'><b>Saved by X-Webpage-Conserve</b></a></td></tr>
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/orbit-summarizer'><b>Summarized by Mozilla Orbit AI</b></a></td></tr>
        <tr><td><a href='https://addons.mozilla.org/zh-CN/firefox/addon/immersive-translate'><b>Translated by 【沉浸式翻译】</b></a></td></tr>
        </tbody>
      </table>
    </body>
</html>" >> all.html

echo "        </tbody>
            </table>
    </body>
</html>" >> docs.html
rm -f *.tmp
