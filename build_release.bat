@echo off
echo 🚀 SmartBLESensor 发布构建脚本
echo ================================

REM 获取版本信息
for /f "tokens=2 delims=: " %%a in ('findstr "version:" pubspec.yaml') do set VERSION=%%a
echo 📱 当前版本: %VERSION%

echo.
echo 🧹 清理项目...
call flutter clean
if errorlevel 1 (
    echo ❌ 清理失败
    pause
    exit /b 1
)

echo.
echo 📦 获取依赖...
call flutter pub get
if errorlevel 1 (
    echo ❌ 依赖获取失败
    pause
    exit /b 1
)

echo.
echo 🎨 生成应用图标...
call dart run flutter_launcher_icons
if errorlevel 1 (
    echo ❌ 图标生成失败
    pause
    exit /b 1
)

echo.
echo 🔍 代码分析...
call flutter analyze
if errorlevel 1 (
    echo ⚠️ 代码分析发现问题，是否继续构建？ (y/n)
    set /p continue=
    if /i not "%continue%"=="y" (
        echo 构建已取消
        pause
        exit /b 1
    )
)

echo.
echo 🧪 运行测试...
call flutter test
if errorlevel 1 (
    echo ⚠️ 测试失败，是否继续构建？ (y/n)
    set /p continue=
    if /i not "%continue%"=="y" (
        echo 构建已取消
        pause
        exit /b 1
    )
)

echo.
echo 🏗️ 构建发布版本APK...
call flutter build apk --release
if errorlevel 1 (
    echo ❌ APK构建失败
    pause
    exit /b 1
)

echo.
echo 📋 复制APK文件...
set APK_NAME=SmartBLESensor-%VERSION%-release.apk
copy "build\app\outputs\flutter-apk\app-release.apk" "%APK_NAME%"
if errorlevel 1 (
    echo ❌ APK复制失败
    pause
    exit /b 1
)

echo.
echo ✅ 构建完成！
echo 📁 APK文件: %APK_NAME%

REM 显示文件信息
for %%i in ("%APK_NAME%") do (
    echo 📊 文件大小: %%~zi 字节
    echo 📅 创建时间: %%~ti
)

echo.
echo 🎉 发布构建成功完成！
echo 📱 APK文件已准备就绪: %APK_NAME%
echo.
echo 📋 下一步操作:
echo   1. 测试APK文件
echo   2. 创建GitHub Release
echo   3. 上传到发布渠道
echo   4. 更新网站下载链接

pause
