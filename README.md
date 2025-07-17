# SmartBLESensor - 智能蓝牙传感器监控应用

一个基于 Flutter 开发的专业级蓝牙传感器数据监控应用，支持实时数据采集、可视化图表、数据记录和 CSV 导出功能。

## ✨ 核心功能

### 🔗 智能蓝牙连接

- **设备自动发现**: 按信号强度排序的智能设备扫描
- **一键连接**: 连接成功后自动返回主页面，带有实时反馈
- **连接状态监控**: 实时显示连接状态和信号强度(RSSI)
- **稳定连接**: 自动断线检测和状态同步

### 📊 实时数据监控

- **通用传感器支持**: 支持任意 float 类型传感器数据
- **实时图表**: 动态更新的数据可视化图表
- **RSSI 监控**: 实时显示蓝牙信号强度和质量
- **数据统计**: 最大值、最小值、平均值等统计信息

### 📱 专业用户界面

- **Material Design 3**: 现代化的设计风格
- **三标签导航**: 设备管理、数据监控、历史记录
- **响应式布局**: 适配不同屏幕尺寸
- **实时反馈**: SnackBar 提示和状态指示

### 💾 数据管理

- **历史记录**: 完整的数据记录功能
- **CSV 导出**: 标准格式数据导出(序号、时间、数值)
- **UUID 配置**: 灵活的 BLE 服务和特征值配置
- **数据清理**: 一键清除历史数据

## 🏗️ 项目架构

```
lib/
├── main.dart                    # 应用入口
├── models/                      # 数据模型层
│   ├── sensor_data.dart        # 通用传感器数据模型
│   ├── device_info.dart        # 设备信息模型
│   ├── bluetooth_state.dart    # 蓝牙状态模型
│   ├── uuid_config.dart        # UUID配置模型
│   └── models.dart             # 模型统一导出
├── services/                    # 业务服务层
│   ├── bluetooth_service.dart  # 蓝牙通信服务
│   ├── uuid_config_service.dart # UUID配置管理
│   └── services.dart           # 服务统一导出
├── providers/                   # 状态管理层
│   ├── bluetooth_provider.dart # 蓝牙状态管理
│   ├── sensor_data_provider.dart # 传感器数据管理
│   └── providers.dart          # 提供者统一导出
├── screens/                     # 页面层
│   ├── home_screen.dart        # 主页面(三标签集成)
│   ├── device_scan_screen.dart # 设备扫描页面
│   └── screens.dart            # 页面统一导出
└── widgets/                     # 组件层
    ├── device_list_item.dart   # 设备列表项组件
    └── widgets.dart            # 组件统一导出
```

## 🛠️ 技术栈

- **框架**: Flutter 3.x
- **状态管理**: Provider 模式
- **蓝牙通信**: flutter_blue_plus ^1.35.5
- **图表可视化**: fl_chart ^0.69.0
- **本地存储**: shared_preferences ^2.3.2
- **权限管理**: permission_handler ^11.3.1
- **日期格式化**: intl ^0.19.0

## 📋 环境要求

- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: >= 3.0.0
- **Android**: API Level 21+ (Android 5.0+)
- **iOS**: 12.0+
- **编译 SDK**: Android 35, iOS 15.0+

## 🚀 快速开始

### 1. 环境准备

```bash
# 检查Flutter环境
flutter doctor

# 克隆项目
git clone <repository-url>
cd smart_sense

# 安装依赖
flutter pub get
```

### 2. 运行应用

```bash
# 运行在连接的设备上
flutter run

# 运行在特定设备
flutter run -d <device-id>

# 构建APK
flutter build apk --release
```

## 🔧 权限配置

### Android 配置

在 `android/app/src/main/AndroidManifest.xml` 中已配置：

```xml
<!-- 蓝牙基础权限 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />

<!-- 位置权限(BLE扫描需要) -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- Android 12+ 蓝牙权限 -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

### iOS 配置

在 `ios/Runner/Info.plist` 中已配置：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>此应用需要蓝牙权限来连接传感器设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>此应用需要蓝牙权限来连接传感器设备</string>
```

## 📖 使用指南

### 设备连接流程

1. **扫描设备**: 点击"扫描设备"按钮
2. **选择设备**: 从按信号强度排序的列表中选择设备
3. **建立连接**: 查看连接进度提示
4. **自动返回**: 连接成功后自动返回主页面

### 数据监控操作

1. **配置 UUID**: 在设备页面配置 BLE 服务和特征值 UUID
2. **开始监听**: 点击"开始监听"按钮启动数据接收
3. **实时查看**: 在监控页面查看实时数据和图表
4. **信号监控**: 观察 RSSI 信号强度变化

### 数据记录管理

1. **开始记录**: 在记录页面点击播放按钮开始记录
2. **查看历史**: 浏览带时间戳的历史数据
3. **导出数据**: 点击导出按钮，支持两种导出方式：
   - **保存到文件**: 直接保存 CSV 文件到设备存储
   - **预览/复制**: 预览 CSV 内容并复制到剪贴板
4. **清理数据**: 使用清除按钮管理存储空间

## 🔌 硬件兼容性

### 支持的设备类型

- **ESP32 系列**: ESP32-DevKit, ESP32-S3 等
- **Arduino BLE**: Arduino Nano 33 BLE 等
- **通用 BLE 设备**: 支持标准 BLE GATT 协议的设备

### 数据格式要求

- **数据类型**: 4 字节 IEEE 754 浮点数
- **传输方式**: BLE Characteristic Notify
- **更新频率**: 建议 1Hz (每秒 1 次)

### 默认 UUID 配置

```
Service UUID: 4fafc201-1fb5-459e-8fcc-c5c9c331914b
Characteristic UUID: beb5483e-36e1-4688-b7f5-ea07361b26a8
```

## 🎯 核心特性详解

### 智能设备排序

- 按 RSSI 信号强度自动排序
- 信号最强的设备显示在顶部
- 提高连接成功率

### 实时 RSSI 监控

- 每 2 秒更新一次信号强度
- 颜色编码: 绿色(优秀) → 橙色(一般) → 红色(较弱)
- 文字描述: 优秀/良好/一般/较弱

### CSV 数据导出

```csv
序号,时间,传感器数据
1,2024-01-15 14:30:01,25.67
2,2024-01-15 14:30:02,25.71
3,2024-01-15 14:30:03,25.69
```

### UUID 配置管理

- 支持多套 UUID 配置
- 自动检测和保存
- 配置导入导出

## 🐛 故障排除

### 常见问题

1. **扫描不到设备**: 检查蓝牙权限和位置权限
2. **连接失败**: 确认设备支持 BLE 且未被其他应用占用
3. **数据接收异常**: 检查 UUID 配置是否正确
4. **应用崩溃**: 查看日志并确保 Flutter 版本兼容

### 调试技巧

```bash
# 查看详细日志
flutter run --verbose

# 检查蓝牙状态
adb shell dumpsys bluetooth_manager

# 清除应用数据
flutter clean && flutter pub get
```

## 🔄 版本历史

### v1.3.0 (2025-01-17) - 当前版本

- ✅ **增强 CSV 导出功能**: 支持文件保存和预览复制两种方式
- ✅ **文件管理**: 自动生成带时间戳的文件名
- ✅ **导出反馈**: 显示文件路径、大小和记录数量
- ✅ **用户体验**: 改进的导出流程和错误处理

### v1.2.0 (2024-12-26)

- ✅ 设备列表按信号强度排序
- ✅ 连接成功反馈和自动返回
- ✅ 实时 RSSI 信号强度监控
- ✅ 基础 CSV 数据导出功能
- ✅ 通用传感器数据支持
- ✅ UUID 配置管理系统
- ✅ 连接状态实时同步

### v1.1.0 (2024-12-25)

- ✅ 基础蓝牙连接功能
- ✅ 实时数据图表
- ✅ 数据记录功能
- ✅ Material Design 3 界面

### v1.0.0 (2024-12-24)

- ✅ 项目初始化
- ✅ 基础架构搭建

## 🤝 贡献指南

1. **Fork 项目** 到你的 GitHub 账户
2. **创建分支** `git checkout -b feature/amazing-feature`
3. **提交更改** `git commit -m 'Add amazing feature'`
4. **推送分支** `git push origin feature/amazing-feature`
5. **创建 PR** 提交 Pull Request

### 开发规范

- 遵循 Dart 代码风格指南
- 添加必要的注释和文档
- 确保所有测试通过
- 更新相关文档

## 📄 许可证

本项目采用 **MIT License** 开源许可证。

## 📞 联系支持

- **项目地址**: [GitHub Repository](https://github.com/your-username/smart_sense)
- **问题反馈**: [GitHub Issues](https://github.com/your-username/smart_sense/issues)
- **功能建议**: [GitHub Discussions](https://github.com/your-username/smart_sense/discussions)

---

**SmartSense** - 让传感器数据监控变得简单而专业 🚀
