@echo off
chcp 65001 >nul 2>&1  :: 设置编码为UTF-8，支持中文文件夹名
setlocal enabledelayedexpansion

:: 检查temp_dir.txt是否存在
if not exist "temp_dir.txt" (
    echo 【错误】当前目录下未找到 temp_dir.txt 文件，请确认文件存在！
    pause
    exit /b 1
)

:: 统计temp_dir.txt中的有效行数（跳过空行）
set "line_count=0"
for /f "delims=" %%i in (temp_dir.txt) do (
    if not "%%i"=="" (
        set /a line_count+=1
    )
)

if !line_count! equ 0 (
    echo 【警告】temp_dir.txt 文件为空或仅包含空行，无文件夹可创建！
    pause
    exit /b 0
)

echo ======================================
echo 开始批量创建文件夹，共需创建 !line_count! 个
echo ======================================
echo.

:: 读取temp_dir.txt每行内容，创建对应文件夹
set "success_count=0"
set "fail_count=0"

for /f "delims=" %%i in (temp_dir.txt) do (
    :: 跳过空行
    if "%%i"=="" (
        echo 【跳过】空行，无文件夹名称
        continue
    )
    
    :: 定义文件夹名称（%%i为从temp_dir.txt读取的每行内容）
    set "folder_name=%%i"
    
    :: 检查文件夹是否已存在
    if exist "!folder_name!" (
        echo 【跳过】文件夹 "!folder_name!" 已存在
        set /a fail_count+=1
    ) else (
        :: 创建文件夹（md = mkdir，支持创建多级目录）
        md "!folder_name!" >nul 2>&1
        
        :: 检查创建是否成功
        if !errorlevel! equ 0 (
            echo 【成功】创建文件夹：!folder_name!
            set /a success_count+=1
        ) else (
            echo 【失败】创建文件夹 "!folder_name!" 失败（可能包含非法字符）
            set /a fail_count+=1
        )
    )
)

echo.
echo ======================================
echo 批量创建完成！
echo 成功创建：!success_count! 个
echo 跳过/失败：!fail_count! 个
echo ======================================
pause
endlocal