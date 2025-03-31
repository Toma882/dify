@echo off
setlocal enabledelayedexpansion

REM 设置源目录（默认为当前目录，可以修改）
set "SOURCE_DIR=%~dp0"

REM 询问用户输入源目录
set /p "INPUT_DIR=请输入要转换的文件夹路径(默认为当前目录，直接回车跳过): "
if not "!INPUT_DIR!"=="" set "SOURCE_DIR=!INPUT_DIR!"

REM 询问用户输入源编码（默认为GBK）
set "SOURCE_ENCODING=GBK"
set /p "INPUT_ENCODING=请输入源文件编码(默认为GBK，常见的有GB18030、GB2312等，直接回车跳过): "
if not "!INPUT_ENCODING!"=="" set "SOURCE_ENCODING=!INPUT_ENCODING!"

echo 将转换 !SOURCE_DIR! 目录下的所有TXT文件从 !SOURCE_ENCODING! 编码到UTF-8格式...

REM 检查是否安装了iconv
where iconv >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo 错误: 找不到iconv命令。请先安装iconv工具。
    echo 您可以从这里下载: https://gnuwin32.sourceforge.net/packages/libiconv.htm
    pause
    exit /b 1
)

REM 为每个TXT文件创建临时文件并进行转换
for /r "%SOURCE_DIR%" %%F in (*.txt) do (
    echo 正在转换: %%F
    iconv -f %SOURCE_ENCODING% -t UTF-8 "%%F" > "%%F.utf8"
    del "%%F"
    rename "%%F.utf8" "%%~nxF"
)

echo 转换完成!
pause 