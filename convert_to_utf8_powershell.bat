@echo off
setlocal enabledelayedexpansion

REM ����ԴĿ¼��Ĭ��Ϊ��ǰĿ¼�������޸ģ�
set "SOURCE_DIR=%~dp0"

REM ѯ���û�����ԴĿ¼
set /p "INPUT_DIR=������Ҫת�����ļ���·��(Ĭ��Ϊ��ǰĿ¼��ֱ�ӻس�����): "
if not "!INPUT_DIR!"=="" set "SOURCE_DIR=!INPUT_DIR!"

echo ��ת�� !SOURCE_DIR! Ŀ¼�µ�����TXT�ļ�ΪUTF-8��ʽ...

REM ʹ��PowerShell���ļ�ת��ΪUTF-8
powershell -Command "$files = Get-ChildItem -Path '%SOURCE_DIR%' -Filter *.txt -Recurse; foreach($file in $files) { $content = Get-Content -Path $file.FullName -Raw -Encoding Default; [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8); echo ('��ת��: ' + $file.FullName) }"

echo ת�����!
pause 