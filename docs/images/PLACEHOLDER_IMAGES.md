# 📸 展示网页图片资源说明

## 🖼️ 需要添加的图片文件

### 1. **hero-phone.png** (300x600px)

- **用途**: 主页横幅区域的手机模型图
- **要求**: 透明背景 PNG 格式，展示应用界面
- **建议**: 使用 iPhone 或 Android 手机模型，将应用截图合成到屏幕中

### 2. **screenshot-1.png** (250x500px)

- **用途**: 设备扫描界面截图
- **内容**: 显示蓝牙设备列表和扫描功能
- **获取**: 在 Android 设备上运行应用并截图

### 3. **screenshot-2.png** (250x500px)

- **用途**: 数据监控界面截图
- **内容**: 显示实时图表和传感器数据
- **获取**: 连接传感器后的监控界面截图

### 4. **screenshot-3.png** (250x500px)

- **用途**: 数据记录界面截图
- **内容**: 显示历史数据记录和导出功能
- **获取**: 数据记录页面的截图

### 5. **qr-code.png** (150x150px)

- **用途**: 下载区域的二维码
- **内容**: GitHub Release 下载页面链接
- **生成**: 使用二维码生成器，输入下载链接

## 📱 获取应用截图的步骤

### 方法 1: Android 设备截图

```bash
# 1. 运行应用
flutter run

# 2. 在设备上操作到相应界面
# 3. 使用设备截图功能 (音量下+电源键)
# 4. 传输截图到电脑
# 5. 裁剪为合适尺寸 (250x500px)
```

### 方法 2: Android Studio 截图

```bash
# 1. 在Android Studio中运行应用
# 2. 使用Device Manager的截图功能
# 3. 保存并裁剪图片
```

### 方法 3: 模拟器截图

```bash
# 1. 在Android模拟器中运行应用
# 2. 使用模拟器的截图功能
# 3. 保存图片到指定目录
```

## 🎨 手机模型图制作

### 推荐工具:

- **Figma** - 免费在线设计工具
- **Canva** - 简单易用的设计平台
- **Photoshop** - 专业图像处理软件

### 制作步骤:

1. 下载手机模型模板
2. 将应用截图放置到手机屏幕区域
3. 调整尺寸和位置
4. 导出为 PNG 格式 (300x600px)
5. 确保背景透明

### 免费资源网站:

- **Unsplash** - 高质量免费图片
- **Freepik** - 免费设计资源
- **Mockup World** - 免费模型模板

## 🔗 二维码生成

### 在线生成器:

- **QR Code Generator** - qr-code-generator.com
- **QRCode Monkey** - qrcode-monkey.com
- **Google Chart API** - chart.googleapis.com

### 生成参数:

- **内容**: `https://ghfast.top/https://github.com/xf959211192/smart_ble_sensor/releases/download/v1.0.0/SmartBLESensor-v1.0.0-release.apk`
- **尺寸**: 150x150px
- **格式**: PNG
- **纠错级别**: 中等 (M)

### 生成命令 (使用 API):

```bash
# Google Chart API
https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=https://ghfast.top/https://github.com/xf959211192/smart_ble_sensor/releases/download/v1.0.0/SmartBLESensor-v1.0.0-release.apk
```

## 📁 文件命名规范

### 严格按照以下命名:

- `hero-phone.png` - 主页手机模型图
- `screenshot-1.png` - 设备扫描截图
- `screenshot-2.png` - 数据监控截图
- `screenshot-3.png` - 数据记录截图
- `qr-code.png` - 下载二维码
- `app-icon.png` - 应用图标 (已存在)

### 文件要求:

- **格式**: PNG (支持透明背景)
- **压缩**: 适度压缩以减小文件大小
- **质量**: 高清晰度，适合网页显示

## 🔄 临时解决方案

在获取真实图片之前，可以使用占位图片：

### 创建占位图片:

```html
<!-- 在HTML中使用占位服务 -->
<img
  src="https://via.placeholder.com/300x600/2196F3/FFFFFF?text=SmartBLESensor"
  alt="手机模型图"
/>
<img
  src="https://via.placeholder.com/250x500/E3F2FD/2196F3?text=设备扫描"
  alt="设备扫描"
/>
<img
  src="https://via.placeholder.com/250x500/E8F5E8/4CAF50?text=数据监控"
  alt="数据监控"
/>
<img
  src="https://via.placeholder.com/250x500/FFF3E0/FF9800?text=数据记录"
  alt="数据记录"
/>
<img
  src="https://via.placeholder.com/150x150/F3E5F5/9C27B0?text=QR"
  alt="二维码"
/>
```

## ✅ 完成检查清单

### 图片准备:

- [ ] hero-phone.png (300x600px)
- [ ] screenshot-1.png (250x500px)
- [ ] screenshot-2.png (250x500px)
- [ ] screenshot-3.png (250x500px)
- [ ] qr-code.png (150x150px)
- [x] app-icon.png (已完成)

### 质量检查:

- [ ] 图片清晰度良好
- [ ] 文件大小适中 (<500KB)
- [ ] 文件命名正确
- [ ] 放置在正确目录

### 网页测试:

- [ ] 本地预览正常
- [ ] 图片加载正常
- [ ] 响应式布局正确
- [ ] 移动端显示良好

---

**状态**: ⏳ **等待图片资源**

**优先级**: 🔴 **高** - 影响网页完整展示

**建议**: 先获取应用截图，再制作手机模型图和二维码
