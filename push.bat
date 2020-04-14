@echo off
:: 解决把中文写入文件乱码问题（声明采用UTF-8编码），936为GBK，437为美国英语
:: https://blog.csdn.net/python_class/article/details/81560470
chcp 65001
:: 开启延迟环境变量扩展（解决for或if中操作变量时提示ECHO OFF问题，用!!取变量）
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
    set /p commitInfo=请输入本次提交到仓库的备注信息：
)else (
    set commitInfo=%~1
)


if "%commitInfo%"=="" (
    goto :ISCOMMITEMPTY
)


:: 文件列表显示到菜单栏
echo * [files](/files.md^)>nav.md
:: 把根目录中的文档写入到菜单栏
for /f "delims=" %%i in ('dir /b  %~dp0 ^| findstr /e ".md"') do (
    if not "%%~ni"=="README" if not "%%~ni"=="nav" if not "%%~ni"=="files" (
        echo.>>nav.md
        echo   * [%%i](/%%i^)>>nav.md
    )
)
:: 把二级目录中的文档写入到菜单栏
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

echo # 文件>files.md
echo.>>files.md
:: 把files目录中的所有文件列出到files.md中
for /f "delims=" %%i in ('dir /s /b %~dp0files') do (
    echo [%%~nxi](/files/%%~nxi ':ignore'^)>>files.md
    echo.>>files.md
)


git add -A

git commit -m "%commitInfo%"

git push


goto :EXIT


:HELP
echo 基本用法：
echo    脚本名 commit-info
echo    commit-info：本次提交到仓库的备注信息
echo.
echo 或者双击脚本名
goto :EXIT


:EXIT
:: 结束延迟环境变量扩展和命令执行
endlocal&exit /b %errorlevel%