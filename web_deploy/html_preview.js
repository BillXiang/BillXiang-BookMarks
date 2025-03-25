// 目标 raw.githubusercontent.com 的 HTML 文件 URL
// const rawUrl = 'https://raw.githubusercontent.com/BillXiang/BillXiang-BookMarks/refs/heads/main/%E4%B9%A6%E7%AD%BE%E5%B7%A5%E5%85%B7%E6%A0%8F/%E8%99%9A%E6%8B%9F%E5%8C%96%26%E5%AE%B9%E5%99%A8/%E6%80%A7%E8%83%BD/KVM%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7-zhurunguang-ChinaUnix%E5%8D%9A%E5%AE%A2%20(2025-03-07%2011%EF%BC%9A08%EF%BC%9A51).html';

const params = {};
const queryString = window.location.search.substring(1);

const [keyEncoded, valueEncoded] = queryString.split('=');
const key = decodeURIComponent(keyEncoded);
// const value = valueEncoded ? 
// decodeURIComponent(valueEncoded.replace(/\+/g, ' ')) : '';

// 创建 URLSearchParams 对象
//const urlParams = new URLSearchParams(window.location.search);
// 获取单个参数（返回第一个值）
const rawUrl = valueEncoded;
// 发起跨域请求
fetch(rawUrl)
    .then(response => response.text())
    .then(html => {
        // 动态创建 iframe 并插入 HTML
        const iframe = document.createElement('iframe');
        document.body.appendChild(iframe);
        iframe.srcdoc = html;
        iframe.style.width = '100%';
        iframe.style.height = '100vh';
        iframe.style.border = '0';
    })
    .catch(error => console.error('Failed to load:', error));