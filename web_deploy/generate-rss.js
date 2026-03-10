const fs = require('fs');
const path = require('path');

// 配置
const CONFIG = {
    inputFile: '../index_content.html',  // 输入文件路径
    outputFile: './feed.xml',           // 输出RSS文件路径
    siteTitle: 'BillXiang BookMarks',   // RSS标题
    siteLink: 'https://billxiang.github.io/BillXiang-BookMarks/',  // 网站链接
    siteDescription: 'BillXiang的书签收藏 - 技术文章聚合',  // 网站描述
    maxItems: 50  // 最大保留条目数
};

/**
 * 解析HTML文件，提取文章信息
 */
function parseHTML(content) {
    const articles = [];

    // 匹配每个文章块（table包裹的内容）
    // 每个文章是一个 <tr><td><table>...</table></td></tr> 结构
    const articleRegex = /<tr><td><table[^>]*>[\s\S]*?<\/table><\/td><\/tr>/g;
    const articles_html = content.match(articleRegex) || [];

    for (const article_html of articles_html) {
        try {
            const article = {};

            // 提取日期 - 从隐藏的td中获取标准格式日期
            const dateMatch = article_html.match(/<td style='display: none;'>_(\d{4}-\d{2}-\d{2})_([\d：]+)_<\/td>/);
            if (dateMatch) {
                const dateStr = dateMatch[1];
                const timeStr = dateMatch[2].replace(/：/g, ':');  // 将中文冒号转为英文
                article.pubDate = new Date(`${dateStr}T${timeStr}`);
            }

            // 提取标题和链接
            const titleMatch = article_html.match(/<tr style='font-size: 25px;'><td><a href="([^"]+)"[^>]*><b>([^<]+)<\/b><\/a><\/td><\/tr>/);
            if (titleMatch) {
                let link = titleMatch[1].trim();
                // 清理链接中的空格和view-source部分
                link = link.split(' ')[0];
                article.link = link;
                article.title = titleMatch[2].trim();
            }

            // 提取Summary
            const summaryMatch = article_html.match(/Summary: ([^<]+)<\/td>/);
            article.description = summaryMatch ? summaryMatch[1].trim() : '';

            // 提取Tags
            const tags = [];
            const tagRegex = /<a href=\.\/tags\/([^\s>]+)[^>]*>>([^<]+)<\/a>/g;
            let tagMatch;
            while ((tagMatch = tagRegex.exec(article_html)) !== null) {
                tags.push(tagMatch[2]);
            }
            article.tags = tags;

            // 只添加有标题和链接的文章
            if (article.title && article.link) {
                articles.push(article);
            }
        } catch (e) {
            console.error('解析文章时出错:', e.message);
        }
    }

    // 按日期降序排序（最新的在前）
    articles.sort((a, b) => b.pubDate - a.pubDate);

    // 限制条目数量
    return articles.slice(0, CONFIG.maxItems);
}

/**
 * 转义XML特殊字符
 */
function escapeXml(str) {
    if (!str) return '';
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&apos;');
}

/**
 * 格式化日期为RFC 822格式
 */
function formatRFC822Date(date) {
    if (!date || isNaN(date.getTime())) {
        date = new Date();
    }
    return date.toUTCString();
}

/**
 * 生成RSS XML
 */
function generateRSS(articles) {
    const now = new Date();

    let itemsXml = articles.map(article => {
        const guid = article.link;  // 使用链接作为唯一标识
        const categories = article.tags.map(tag => 
            `    <category>${escapeXml(tag)}</category>`
        ).join('\n');

        return `  <item>
    <title>${escapeXml(article.title)}</title>
    <link>${escapeXml(article.link)}</link>
    <description>${escapeXml(article.description)}</description>
    <pubDate>${formatRFC822Date(article.pubDate)}</pubDate>
    <guid>${escapeXml(guid)}</guid>
${categories}
  </item>`;
    }).join('\n\n');

    return `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title>${escapeXml(CONFIG.siteTitle)}</title>
  <link>${escapeXml(CONFIG.siteLink)}</link>
  <description>${escapeXml(CONFIG.siteDescription)}</description>
  <language>zh-CN</language>
  <lastBuildDate>${formatRFC822Date(now)}</lastBuildDate>
  <atom:link href="${escapeXml(CONFIG.siteLink + CONFIG.outputFile.replace('./', ''))}" rel="self" type="application/rss+xml" />

${itemsXml}

</channel>
</rss>`;
}

/**
 * 主函数
 */
function main() {
    try {
        // 读取输入文件
        console.log(`正在读取文件: ${CONFIG.inputFile}`);
        const content = fs.readFileSync(CONFIG.inputFile, 'utf-8');

        // 解析文章
        console.log('正在解析文章...');
        const articles = parseHTML(content);
        console.log(`成功解析 ${articles.length} 篇文章`);

        if (articles.length === 0) {
            console.warn('警告: 未找到任何文章，请检查输入文件格式');
            return;
        }

        // 显示前3篇文章信息
        console.log('\n最新的3篇文章:');
        articles.slice(0, 3).forEach((article, i) => {
            console.log(`${i + 1}. ${article.title}`);
            console.log(`   日期: ${article.pubDate}`);
            console.log(`   链接: ${article.link}`);
            console.log(`   标签: ${article.tags.join(', ')}`);
            console.log('');
        });

        // 生成RSS
        const rss = generateRSS(articles);

        // 写入文件
        fs.writeFileSync(CONFIG.outputFile, rss, 'utf-8');
        console.log(`\nRSS文件已生成: ${CONFIG.outputFile}`);
        console.log(`文件大小: ${(rss.length / 1024).toFixed(2)} KB`);

    } catch (error) {
        console.error('错误:', error.message);
        process.exit(1);
    }
}

// 运行
main();
