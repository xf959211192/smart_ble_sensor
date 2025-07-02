@echo off
echo 📸 SmartBLESensor 图片保存助手
echo ================================

echo.
echo 🎯 目标目录: docs\images\
echo.

REM 检查images目录是否存在
if not exist "images" (
    echo 📁 创建images目录...
    mkdir images
)

echo 📋 需要保存的图片文件:
echo.
echo   1. screenshot-1.png  (设备管理界面)
echo   2. screenshot-2.png  (实时监控界面) 
echo   3. screenshot-3.png  (数据记录界面)
echo   4. qr-code.png       (下载二维码)
echo.

echo 💡 保存方法:
echo.
echo   方法1: 手动保存 (推荐)
echo   - 右键点击聊天中的图片
echo   - 选择"图片另存为"
echo   - 保存到 docs\images\ 目录
echo.
echo   方法2: 拖拽保存
echo   - 将图片拖拽到 docs\images\ 文件夹
echo.
echo   方法3: 复制粘贴
echo   - 如果图片已下载到其他位置
echo   - 复制到 docs\images\ 目录
echo.

echo 🔍 当前images目录内容:
dir images\*.png 2>nul
if errorlevel 1 (
    echo   (暂无PNG图片文件)
) else (
    echo.
)

echo.
echo ✅ 保存完成后运行以下命令验证:
echo    dir images\*.png
echo.
echo 🌐 然后可以打开网页预览:
echo    cd docs
echo    python -m http.server 8000
echo    访问: http://localhost:8000
echo.

pause
