@echo off
echo 🧹 SmartBLESensor 项目清理脚本
echo ================================

echo.
echo 🗂️ 清理构建文件和缓存...
call flutter clean
if errorlevel 1 (
    echo ❌ Flutter清理失败
) else (
    echo ✅ Flutter构建文件已清理
)

echo.
echo 🗑️ 删除临时文件...

REM 删除Android临时文件
if exist "android\local.properties" (
    del "android\local.properties"
    echo ✅ 删除 android\local.properties
)

if exist "android\*.iml" (
    del "android\*.iml"
    echo ✅ 删除 Android IntelliJ 模块文件
)

REM 删除iOS临时文件
if exist "ios\Podfile.lock" (
    del "ios\Podfile.lock"
    echo ✅ 删除 ios\Podfile.lock
)

if exist "ios\Pods" (
    rmdir /s /q "ios\Pods"
    echo ✅ 删除 ios\Pods 目录
)

REM 删除macOS临时文件
if exist "macos\Podfile.lock" (
    del "macos\Podfile.lock"
    echo ✅ 删除 macos\Podfile.lock
)

if exist "macos\Pods" (
    rmdir /s /q "macos\Pods"
    echo ✅ 删除 macos\Pods 目录
)

REM 删除Windows临时文件
if exist "windows\flutter\ephemeral" (
    rmdir /s /q "windows\flutter\ephemeral"
    echo ✅ 删除 Windows ephemeral 目录
)

REM 删除Linux临时文件
if exist "linux\flutter\ephemeral" (
    rmdir /s /q "linux\flutter\ephemeral"
    echo ✅ 删除 Linux ephemeral 目录
)

REM 删除Web临时文件
if exist "web\*.js.map" (
    del "web\*.js.map"
    echo ✅ 删除 Web source map 文件
)

REM 删除开发工具配置文件
if exist "devtools_options.yaml" (
    del "devtools_options.yaml"
    echo ✅ 删除 devtools_options.yaml
)

echo.
echo 📊 显示清理后的项目大小...
for /f "tokens=3" %%a in ('dir /s /-c ^| find "个文件"') do set size=%%a
echo 项目总大小: %size% 字节

echo.
echo ✅ 项目清理完成！
echo.
echo 💡 提示:
echo   - 下次运行前需要执行: flutter pub get
echo   - 如果使用iOS/macOS，需要执行: cd ios && pod install
echo   - 构建前建议运行: flutter analyze

pause
