@echo off
chcp 65001 >nul 2>&1  :: 设置编码为UTF-8，避免中文乱码
setlocal enabledelayedexpansion  :: 启用延迟变量扩展，支持循环内变量实时更新

:: 定义原始文件的前缀
set "source_prefix=1901-01-01-"
set "source_suffix=.md"

:: 检查temp_file.txt是否存在
if not exist "temp_file.txt" (
    echo 错误：当前目录下未找到 temp_file.txt 文件！
    pause
    exit /b 1
)

    set "source_file=xxx.md"

:: 读取temp_file.txt中的每一行内容（即xxx）
for /f "delims=" %%i in (temp_file.txt) do (
    :: 拼接原始文件名和新文件名
    set "new_file=!source_prefix!%%i!source_suffix!"  :: 新文件添加“_副本”区分，你可按需修改
    
    :: 检查原始文件是否存在
    if exist "!source_file!" (
        :: 执行复制操作
        copy "!source_file!" "!new_file!" >nul 2>&1
        if !errorlevel! equ 0 (
            echo 成功复制：!source_file! --^> !new_file!
        ) else (
            echo 失败：复制 !source_file! 时出错
        )
    ) else (
        echo 警告：未找到文件 !source_file!，跳过
    )
)

echo.
echo 批量复制操作完成！
pause
endlocal