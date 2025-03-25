const params = {};
const queryString = window.location.search.substring(1);

const [keyEncoded, valueEncoded] = queryString.split('=');
const key = decodeURIComponent(keyEncoded);

// 获取单个参数（返回第一个值）
const rawUrl = valueEncoded;
console.log(rawUrl);
// 从 URL 获取 MD 内容
async function getMarkdownContent(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.text();
    } catch (error) {
        console.error('获取 MD 内容时出错:', error);
        return '';
    }
}

// 初始化 EasyMDE 并设置内容
async function initEasyMDE() {
    const mdContent = await getMarkdownContent(rawUrl);
    const easyMDE = new EasyMDE({
        //element: document.getElementById('editor'),
        initialValue: mdContent,
        spellChecker: false,
        autoDownloadFontAwesome: false,
        previewClass: ['markdown-body'],
        readOnly: true // 只读模式，仅用于展示
    });
}

// 调用初始化函数
initEasyMDE();