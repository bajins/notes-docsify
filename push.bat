@echo off
:: ���������д���ļ��������⣨��������UTF-8���룩��936ΪGBK��437Ϊ����Ӣ��
:: https://blog.csdn.net/python_class/article/details/81560470
::chcp 65001
:: �����ӳٻ���������չ�����for��if�в�������ʱ��ʾECHO OFF���⣬��!!ȡ������
setlocal EnableDelayedExpansion

if "%~1"=="/?" (
    goto :HELP
)
if "%~1"=="help" (
    goto :HELP
)
if "%~1"=="-help" (
    goto :HELP
)
if "%~1"=="/help" (
    goto :HELP
)


:ISCOMMITEMPTY
if "%~1"=="" (
    set /p commitInfo=�����뱾���ύ���ֿ�ı�ע��Ϣ��
)else (
    set commitInfo=%~1
)


if "%commitInfo%"=="" (
    goto :ISCOMMITEMPTY
)


:: �ļ��б���ʾ���˵���
echo * [files](/files.md^)>nav.md
:: �Ѹ�Ŀ¼�е��ĵ�д�뵽�˵���
for /f "delims=" %%i in ('dir /b  %~dp0 ^| findstr /e ".md"') do (
    if not "%%~ni"=="README" if not "%%~ni"=="nav" if not "%%~ni"=="files" (
        echo.>>nav.md
        echo   * [%%i](/%%i^)>>nav.md
    )
)
:: �Ѷ���Ŀ¼�е��ĵ�д�뵽�˵���
for /f "delims=" %%i in ('dir /b /ad  %~dp0 ^| findstr /v ".git images files"') do (
    echo.>>nav.md
    echo * [%%i](/%%i/README.md^)>>nav.md
    for /f "delims=" %%a in ('dir /s /b  %%i ^| findstr /e ".md"') do (
        if not "%%~na"=="README" (
            echo.>>nav.md
            echo   * [%%~na](/%%i/%%~nxa^)>>nav.md
        )
    )
)

echo # �ļ�>files.md
echo.>>files.md
:: ��filesĿ¼�е������ļ��г���files.md��
for /f "delims=" %%i in ('dir /s /b %~dp0files') do (
    echo [%%~nxi](/files/%%~nxi ':ignore'^)>>files.md
    echo.>>files.md
)


git add -A

git commit -m "%commitInfo%"

git push


goto :EXIT


:HELP
echo �����÷���
echo    �ű��� commit-info
echo    commit-info�������ύ���ֿ�ı�ע��Ϣ
echo.
echo ����˫���ű���
goto :EXIT


:EXIT
:: �����ӳٻ���������չ������ִ��
endlocal&exit /b %errorlevel%