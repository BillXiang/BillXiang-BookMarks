#!/usr/bin/bash
rm -f *.tmp

echo "<!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
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
      <table id="myTable">
        <thead><tr><th><a href='./index.html'>Recently Read</a></th><th>All</th></tr></thead>
        <tbody>" > all.html

echo "<!DOCTYPE html>
  <html>
    <head>
      <meta charset="UTF-8">
      <title>BillXiang</title>
      <link rel="stylesheet" type="text/css" href="./web_deploy/style.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
      <script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>
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
      <table id="myTable">
        <thead><tr><th>Recently Read</th><th><a href='./all.html'>All</a></th></tr></thead>
        <tbody>" > index.html

read_dir(){
    for file in "$1"/*;
    do
        #echo $file"####"
        if [ -d "$file" ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                #echo "DIR"
                read_dir "$file"
            fi
        else
            html=$(echo $file|grep "html$"|wc -l)
            
            name=${file/\.\//}
            name=${name/书签工具栏/}
            name=${name/(*).html/}
            echo $name
            if [[ "$html" -ne 0 ]];then
                ori_url=`head -n 3 "$file"|tail -n 1`
                ori_url=${ori_url:6}

                echo $file | awk -F'[/()]' '{print $(NF-1), $(NF-2)}' | while read a b c
                do
                    echo "<tr><th><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$name</a></th></tr>" >> url.tmp
                    echo "<tr><td>收录日期 ${a}_${b}</td><td><a href='$ori_url'>原文链接</a></td></tr>" >> url.tmp
                done
            else
                echo "<tr><td>____________________</td><td></td><td><a href=\"https://billxiang.github.io/BillXiang-BookMarks/$file\">$name</a></td></tr>" >> url.tmp
            fi

        fi
    done
}

echo "" > url.tmp
read_dir "."
cat url.tmp |LC_ALL=C  sort -t'_' -rn -k1 -k2 -k3 -k4 -k5 -k6 |head -n 20 >> index.html
cat url.tmp |LC_ALL=C  sort -t'_' -rn -k1 -k2 -k3 -k4 -k5 -k6 | grep -v "web_deploy" >> all.html
rm -f url.tmp

echo "  </tbody>
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

echo "  </tbody>
      </table>
    </body>
</html>" >> all.html
rm -f *.tmp
