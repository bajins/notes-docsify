:: -------------------------------------------------------------------
::                          ��ӿ�ݷ�ʽ
::                     by https://www.bajins.com
::                   GitHub https://woytu.github.io
:: -------------------------------------------------------------------


@echo off
if "%1" == "h" goto begin
mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close) && exit
:begin

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