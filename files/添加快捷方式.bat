:: -------------------------------------------------------------------
::                          ��ӿ�ݷ�ʽ
::                     by https://www.bajins.com
::                   GitHub https://woytu.github.io
:: -------------------------------------------------------------------


@echo off
:-------------------------------------------------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto GetAdmin )
:UACPrompt
    ::if not "%~1"=="" set file= ""%~1""
    ::echo CreateObject("Shell.Application").ShellExecute "cmd.exe", "/c %~s0%file%", "", "runas", 1 > "%temp%\getadmin.vbs"
    echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 > "%temp%\getadmin.vbs" 
    "%temp%\getadmin.vbs"
    exit /B
:GetAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:StartCommand
:-------------------------------------------------------------------------------

::���ÿ�ݷ�ʽ���ƣ���ѡ��
:: %~dp0 ��ǰ����Ŀ¼
:: %0 ��ǰִ�нű�·��
set LnkName=����.exe

::���ÿ�ݷ�ʽ��ʾ��˵������ѡ��
set Desc=����

:: ���ÿ�ݷ�ʽ���·����DesKtop��Startup��AllUsersStartup��AllUsersDesktop
set folder=DesKtop


::���ó�����ļ�������·������ѡ��
set Program=%~dp0%LnkName%

::���ó���Ĺ���·����һ��Ϊ������Ŀ¼�����������գ��ű������з���·��
set WorkDir=%~dp0

if not defined WorkDir call:GetWorkDir "%Program%"

::����
(
	echo Set WshShell=CreateObject("WScript.Shell"^)
	echo folder=WshShell.SpecialFolders("%folder%"^)
	echo Set oShellLink=WshShell.CreateShortcut(folder^&"\%LnkName%.lnk"^)
	echo oShellLink.TargetPath="%Program%"
	echo oShellLink.WorkingDirectory="%WorkDir%"
	echo oShellLink.WindowStyle=1
	echo oShellLink.Description="%Desc%"
	echo oShellLink.Save
	echo Msgbox("��ݷ�ʽ�����ɹ���"^)
) > makelnk.vbs

makelnk.vbs
del /f /q makelnk.vbs
exit

goto :eof

:GetWorkDir
	set WorkDir=%~dp1
	set WorkDir=%WorkDir:~,-1%

goto :eof