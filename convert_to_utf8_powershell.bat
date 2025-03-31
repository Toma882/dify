@echo off
setlocal enabledelayedexpansion

REM 设置源目录（默认为当前目录，可以修改）
set "SOURCE_DIR=%~dp0"

REM 询问用户输入源目录
set /p "INPUT_DIR=请输入要转换的文件夹路径(默认为当前目录，直接回车跳过): "
if not "!INPUT_DIR!"=="" set "SOURCE_DIR=!INPUT_DIR!"

echo 将转换 !SOURCE_DIR! 目录下的所有TXT文件为UTF-8格式...

REM 使用PowerShell将文件转换为UTF-8
powershell -Command "$files = Get-ChildItem -Path '%SOURCE_DIR%' -Filter *.txt -Recurse; foreach($file in $files) { $content = Get-Content -Path $file.FullName -Raw -Encoding Default; [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8); echo ('已转换: ' + $file.FullName) }"

echo 转换完成!
pause 