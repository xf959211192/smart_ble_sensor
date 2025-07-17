# SmartBLESensor 展示网页

这是 SmartBLESensor 智能蓝牙传感器监控应用的官方展示网页。

## 🌐 在线访问

您可以通过以下方式访问展示网页：

### GitHub Pages (推荐)

1. 在 GitHub 仓库设置中启用 GitHub Pages
2. 选择 `docs` 文件夹作为源
3. 访问: `https://ble.xf17.me/`

### 本地预览

```bash
# 在项目根目录下
cd docs
python -m http.server 8000
# 或使用Node.js
npx serve .
```

然后在浏览器中访问 `http://localhost:8000`

## 📁 文件结构

```
docs/
├── index.html          # 主页面
├── styles.css          # 样式文件
├── script.js           # JavaScript功能
├── favicon.ico         # 网站图标
├── images/             # 图片资源
│   ├── app-icon.png    # 应用图标
│   ├── hero-phone.png  # 主页手机模型图 (需要添加)
│   ├── screenshot-1.png # 应用截图1 (需要添加)
│   ├── screenshot-2.png # 应用截图2 (需要添加)
│   ├── screenshot-3.png # 应用截图3 (需要添加)
│   └── qr-code.png     # 下载二维码 (需要添加)
└── README.md           # 说明文档
```

## 🎨 网页特性

### ✨ 现代化设计

- **Material Design 3** 设计风格
- **响应式布局** 适配所有设备
- **平滑动画** 提升用户体验
- **渐变背景** 视觉吸引力

### 📱 功能模块

- **导航栏** - 固定导航，移动端汉堡菜单
- **主页横幅** - 应用介绍和下载按钮
- **功能特性** - 6 个核心功能展示
- **技术规格** - 开发框架和系统要求
- **应用截图** - 界面预览
- **下载区域** - APK 下载和二维码
- **支持反馈** - 问题报告和功能建议
- **页脚** - 链接和版权信息

### 🔧 交互功能

- **平滑滚动** 锚点导航
- **滚动动画** 元素渐入效果
- **移动端菜单** 响应式导航
- **设备检测** 自动识别 Android/iOS
- **复制链接** 一键复制下载地址
- **通知提示** 操作反馈

## 🖼️ 图片资源

### 需要添加的图片文件：

1. **hero-phone.png** (300x600px)

   - 手机模型图，展示应用界面
   - 建议使用透明背景的 PNG 格式

2. **screenshot-1.png** (250x500px)

   - 设备扫描界面截图

3. **screenshot-2.png** (250x500px)

   - 数据监控界面截图

4. **screenshot-3.png** (250x500px)

   - 数据记录界面截图

5. **qr-code.png** (150x150px)
   - GitHub Release 下载页面的二维码

### 图片获取方法：

#### 应用截图

```bash
# 在Android设备上运行应用
flutter run
# 使用Android Studio或设备截图功能
# 裁剪为合适尺寸并保存到 docs/images/
```

#### 二维码生成

- 使用在线二维码生成器
- 输入 URL: `https://ghfast.top/https://github.com/xf959211192/smart_ble_sensor/releases/download/v1.0.0/SmartBLESensor-v1.0.0-release.apk`
- 生成 150x150px 的 PNG 格式

#### 手机模型图

- 使用设计工具(如 Figma、Sketch)创建
- 或从免费资源网站下载手机模型
- 将应用截图合成到手机屏幕中

## 🚀 部署到 GitHub Pages

### 1. 启用 GitHub Pages

1. 进入 GitHub 仓库设置页面
2. 滚动到 "Pages" 部分
3. 在 "Source" 中选择 "Deploy from a branch"
4. 选择 "main" 分支和 "docs" 文件夹
5. 点击 "Save"

### 2. 自定义域名 (可选)

如果您有自定义域名：

1. 在 "Custom domain" 中输入域名
2. 在域名 DNS 设置中添加 CNAME 记录指向 `xf959211192.github.io`

### 3. 访问网站

部署完成后，网站将在以下地址可用：

- `https://ble.xf17.me/`

## 🔧 自定义配置

### 修改内容

- 编辑 `index.html` 修改页面内容
- 编辑 `styles.css` 修改样式和颜色
- 编辑 `script.js` 添加交互功能

### 颜色主题

在 `styles.css` 中的 `:root` 部分修改 CSS 变量：

```css
:root {
  --primary-color: #2196f3; /* 主色调 */
  --secondary-color: #03dac6; /* 辅助色 */
  --background-color: #fafafa; /* 背景色 */
  /* ... 其他颜色变量 */
}
```

### 添加新功能

- 在相应的 HTML 部分添加内容
- 在 CSS 中添加样式
- 在 JavaScript 中添加交互逻辑

## 📊 SEO 优化

网页已包含基础 SEO 优化：

- **Meta 标签** - 描述、关键词
- **语义化 HTML** - 正确的标签结构
- **图片 Alt 属性** - 无障碍访问
- **结构化数据** - 搜索引擎友好

## 🔍 性能优化

- **图片优化** - 使用适当的格式和尺寸
- **CSS/JS 压缩** - 生产环境建议压缩
- **CDN 加速** - 使用 CDN 加载字体和图标
- **懒加载** - 图片懒加载提升性能

## 📱 浏览器兼容性

支持的浏览器：

- Chrome 60+
- Firefox 60+
- Safari 12+
- Edge 79+
- 移动端浏览器

## 🐛 问题排查

### 常见问题：

1. **图片不显示**

   - 检查图片路径是否正确
   - 确保图片文件存在于 `docs/images/` 目录

2. **样式异常**

   - 检查 CSS 文件是否正确加载
   - 验证 CSS 语法是否正确

3. **JavaScript 功能失效**
   - 打开浏览器开发者工具查看错误
   - 检查 JavaScript 语法

### 调试方法：

- 使用浏览器开发者工具
- 检查控制台错误信息
- 验证网络请求状态

---

**网页状态**: 🟢 **基础框架完成**

**下一步**: 添加应用截图和手机模型图，然后部署到 GitHub Pages
