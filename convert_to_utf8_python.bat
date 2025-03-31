@echo off
setlocal enabledelayedexpansion

REM 设置源目录（默认为当前目录，可以修改）
set "SOURCE_DIR=%~dp0"

REM 询问用户输入源目录
set /p "INPUT_DIR=请输入要转换的文件夹路径(默认为当前目录，直接回车跳过): "
if not "!INPUT_DIR!"=="" set "SOURCE_DIR=!INPUT_DIR!"

REM 检查Python是否安装
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo 错误: 找不到Python。请安装Python后再试。
    pause
    exit /b 1
)

echo 将转换 !SOURCE_DIR! 目录下的所有TXT文件为UTF-8格式...

REM 创建临时Python脚本
echo import os, sys, chardet > "%TEMP%\convert_to_utf8.py"
echo def convert_to_utf8(file_path): >> "%TEMP%\convert_to_utf8.py"
echo     try: >> "%TEMP%\convert_to_utf8.py"
echo         # 检测文件编码 >> "%TEMP%\convert_to_utf8.py"
echo         with open(file_path, 'rb') as f: >> "%TEMP%\convert_to_utf8.py"
echo             raw_data = f.read() >> "%TEMP%\convert_to_utf8.py"
echo         result = chardet.detect(raw_data) >> "%TEMP%\convert_to_utf8.py"
echo         encoding = result['encoding'] if result['encoding'] else 'utf-8' >> "%TEMP%\convert_to_utf8.py"
echo         print(f"检测到编码: {encoding} (置信度: {result['confidence']:.2f}) - {file_path}") >> "%TEMP%\convert_to_utf8.py"
echo         # 读取原始内容 >> "%TEMP%\convert_to_utf8.py"
echo         with open(file_path, 'r', encoding=encoding, errors='replace') as f: >> "%TEMP%\convert_to_utf8.py"
echo             content = f.read() >> "%TEMP%\convert_to_utf8.py"
echo         # 以UTF-8写回 >> "%TEMP%\convert_to_utf8.py"
echo         with open(file_path, 'w', encoding='utf-8') as f: >> "%TEMP%\convert_to_utf8.py"
echo             f.write(content) >> "%TEMP%\convert_to_utf8.py"
echo         print(f"已转换为UTF-8: {file_path}") >> "%TEMP%\convert_to_utf8.py"
echo         return True >> "%TEMP%\convert_to_utf8.py"
echo     except Exception as e: >> "%TEMP%\convert_to_utf8.py"
echo         print(f"转换失败: {file_path} - 错误: {str(e)}") >> "%TEMP%\convert_to_utf8.py"
echo         return False >> "%TEMP%\convert_to_utf8.py"
echo def process_directory(directory): >> "%TEMP%\convert_to_utf8.py"
echo     success = 0 >> "%TEMP%\convert_to_utf8.py"
echo     failed = 0 >> "%TEMP%\convert_to_utf8.py"
echo     for root, dirs, files in os.walk(directory): >> "%TEMP%\convert_to_utf8.py"
echo         for file in files: >> "%TEMP%\convert_to_utf8.py"
echo             if file.lower().endswith('.txt'): >> "%TEMP%\convert_to_utf8.py"
echo                 file_path = os.path.join(root, file) >> "%TEMP%\convert_to_utf8.py"
echo                 if convert_to_utf8(file_path): >> "%TEMP%\convert_to_utf8.py"
echo                     success += 1 >> "%TEMP%\convert_to_utf8.py"
echo                 else: >> "%TEMP%\convert_to_utf8.py"
echo                     failed += 1 >> "%TEMP%\convert_to_utf8.py"
echo     print(f"\n转换统计:") >> "%TEMP%\convert_to_utf8.py"
echo     print(f"成功: {success}") >> "%TEMP%\convert_to_utf8.py"
echo     print(f"失败: {failed}") >> "%TEMP%\convert_to_utf8.py"
echo if __name__ == '__main__': >> "%TEMP%\convert_to_utf8.py"
echo     if len(sys.argv) > 1: >> "%TEMP%\convert_to_utf8.py"
echo         directory = sys.argv[1] >> "%TEMP%\convert_to_utf8.py"
echo     else: >> "%TEMP%\convert_to_utf8.py"
echo         directory = '.' >> "%TEMP%\convert_to_utf8.py"
echo     if not os.path.exists(directory): >> "%TEMP%\convert_to_utf8.py"
echo         print(f"错误: 目录不存在 - {directory}") >> "%TEMP%\convert_to_utf8.py"
echo         sys.exit(1) >> "%TEMP%\convert_to_utf8.py"
echo     print(f"开始转换目录: {directory}") >> "%TEMP%\convert_to_utf8.py"
echo     process_directory(directory) >> "%TEMP%\convert_to_utf8.py"

REM 检查并安装chardet库
python -c "import chardet" 2>nul
if %ERRORLEVEL% neq 0 (
    echo 正在安装必要的Python库 chardet...
    pip install chardet
)

REM 运行Python脚本
python "%TEMP%\convert_to_utf8.py" "%SOURCE_DIR%"

echo 转换完成!
pause 