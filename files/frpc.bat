1>1/* ::
:: by bajins https://www.bajins.com

@ECHO OFF
color 0a
Title FRPC�������� by:bajins.com
:: ���ڸ߿�40*120
REG ADD "HKEY_CURRENT_USER\Console" /t REG_DWORD /v WindowSize /d 0x00280078 /f >nul
:: ��Ļ�������߿�1000*120
REG ADD "HKEY_CURRENT_USER\Console" /t REG_DWORD /v ScreenBufferSize /d 0x03e80078 /f >nul

:: �����ӳٻ���������չ
:: ���for��if�в�������ʱ��ʾECHO OFF���⣬��!!ȡ����
:: �������jscript��ʾ�����������
setlocal enabledelayedexpansion

if "%~1"=="/?" (
    cscript -nologo -e:jscript "%~f0" /help:%1
    goto :EXIT
)
if "%~1"=="/help" (
    cscript -nologo -e:jscript "%~f0" /help:%1
    goto :EXIT
)


set serverHost=woetu.com
set serverProt=5443
set token=woetu
set httpPort=7552

:START
ECHO.
ECHO             ==========================================================================
ECHO.
ECHO                                      Bajins FRPC�ͻ�����������
ECHO.
ECHO                                      �������䣺admin@woytu.com
ECHO.
ECHO                                  ������ҳ��https://www.bajins.com
ECHO.
ECHO                                  github��https://github.com/woytu
ECHO.
ECHO                                      ���ʹ�ã���ֹ���ڷǷ���;��
ECHO.
ECHO             ==========================================================================
ECHO.
ECHO.

:: ִ��JavaScript�ű�
cscript -nologo -e:jscript "%~f0"

if not "%errorlevel%" == "0" (
    @cmd /k
)

:TUNNEL
ECHO.
ECHO.
ECHO             �����Զ�������������硰aa�� �����������Ĵ�͸����Ϊ����aa.%serverHost%��
ECHO.
ECHO.

:CID
set /p clientid=�������Զ������������
if "%clientid%"=="" (
    goto :CID
)

:: �ж��Ƿ�Ϊ���֡���ĸ����|���˲����пո�
:: ע�������и�bug������[^0-9]ȡ����ƥ�䵽.��ͨ��
ECHO %clientid%|findstr "^[a-z0-9]*$" >nul || (
    ECHO.
    ECHO.������������ΪСд��ĸ�����֣�
    ECHO.
    goto :CID
)

ECHO.
ECHO.

:PT
set /p port=�����뱾�ض˿ڣ�
if "%port%"=="" (
    goto :PT
)

:: �ж��Ƿ�Ϊ�����֣���|���˲����пո�
:: ע�������и�bug������[^0-9]ȡ����ƥ�䵽.��ͨ��
ECHO %port%|findstr "^[0-9]*$" >nul || (
    ECHO.
    ECHO.�˿ڱ���Ϊ�����֣�
    ECHO.
    goto :PT
)

ECHO.
ECHO.

ECHO ���ʵ�ַ��http://%clientid%.%serverHost%:%httpPort%

:: �����ļ�
set iniFile="frpc.ini"
:: ��־�ļ�
set logFile=frpc.log

if exist %iniFile% del frpc.ini >nul

(
    ECHO [common]
    ECHO # frps��ַ
    ECHO server_addr = %serverHost%
    ECHO # frps�˿�
    ECHO server_port = %serverProt%
    ECHO # frps��֤����
    ECHO token = %token%
    ECHO # ��¼ʧ������
    ECHO login_fail_exit = true
    ECHO # ָ����־�ļ�
    ECHO log_file = %logFile%
    ECHO # ָ����־��ӡ����
    ECHO log_level = info
    ECHO # ָ����־�洢�������
    ECHO log_max_days = 7
    ECHO. 
    ECHO. 
    ECHO # �������
    ECHO [web_%clientid%]
    ECHO # ��������
    ECHO type = http
    ECHO # ����IP
    ECHO local_ip = 127.0.0.1
    ECHO # ���ض˿�
    ECHO local_port = %port%
    ECHO # �Զ����������
    ECHO subdomain = %clientid%
    ECHO # �Զ�������,subdomain���ú��޷�ʹ�ô˲���
    ECHO # custom_domains = %clientid%.%serverHost%
    ECHO. 
) > %iniFile%

ECHO.
ECHO.


cd %~dp0
:: ��������
taskkill /f /im frpc.exe 1>nul 2>nul
:: �����־�ļ�������ɾ��
if exist %logFile% del %logFile% >nul

:: ����VisualBasicScript�����ʾvbs����
mshta vbscript:CreateObject("WScript.Shell").Run("cmd /c frpc.exe -c frpc.ini",0,false)(window.close)

ECHO.��������frpc�����Ժ�......

:: ��ʱ�ȴ�10��
timeout /T 10 /NOBREAK >nul

ECHO.
ECHO.

:: ��ȡ��������PID
for /f "skip=3 tokens=2" %%a in ('tasklist /fi "imagename eq frpc*"') do set taskReslut= %%a
:: �ж�PID�Ƿ�Ϊ��
if "%taskReslut%"=="" (
    ECHO.
    ECHO.����ʧ�ܣ�
    ECHO.
    @cmd /k
) else (
    ECHO ���гɹ�PID��%taskReslut%
)

if not exist %logFile% (
    ECHO.
    ECHO.��־�ļ������ڣ����ֶ�����Ƿ����гɹ���
    ECHO.
    @cmd /k
)


findstr /i /c:"login to server failed" %logFile% >nul && (
    ECHO.
    ECHO.��¼��������ʧ�ܣ�
    ECHO.
    @cmd /k
)

findstr /i /c:"start proxy error" %logFile% >nul && (
    ECHO.
    ECHO.����ʧ�ܣ��������û��������ã�
    ECHO.
    @cmd /k
)

findstr /i /c:"login to server success" %logFile% >nul && (
    ECHO.
    ECHO.��¼frps�ɹ���
    ECHO.
) || (
    ECHO.
)

findstr /i /c:"start proxy success" %logFile% >nul && (
    ECHO.
    ECHO.��̨����frpc��ɣ�
    ECHO.
) || (
    ECHO.
)


ECHO.
ECHO.������frpc��־��Ϣ��
ECHO.
type %logFile%
ECHO.

pause

goto :EXIT

:EXIT
:: �����ӳٻ���������չ������ִ��
endlocal&exit /b %errorlevel%

*/

// ****************************  JavaScript  *******************************


var Argv = WScript.Arguments;
for (i = 0; i < Argv.length; i++) {
    WScript.Echo("������", Argv(i));
}
var ArgvName = Argv.Named;

if (ArgvName.Item("help") != "" && ArgvName.Item("help") != null) {
    help();
    // �����˳�
    WScript.Quit(0);
}

if (ArgvName.Item("autoRun") == "1") {
    autoStart("startup");
}

try {
    run();
} catch (err) {
    WScript.Echo("����", err.message);
    // �쳣�˳�
    WScript.Quit(1);
}

function run() {
    // ����shell����
    var shell = new ActiveXObject("WScript.shell");
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ��ǰ�ļ�����Ŀ¼
    var currentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder;

    var cmd = "cmd /c ";

    WScript.Echo("��ʼ��ȡ�������°汾��......\n");

    // �����ȡ���°汾��Ϣ
    var json = request("get", "https://api.github.com/repos/fatedier/frp/releases/latest", "json");
    // ���°汾��
    var version = json.name.substring(1);

    WScript.Echo("��ǰ�������°汾�ţ�", version, "\n");

    var sys = getSystem();
    var url = "";
    for (var i = 0; i < json.assets.length; i++) {
        var os = json.assets[i];
        var v = os.name.split("_");
        if (v[1] == version && v[2] == sys.os && v[3].split(".")[0] == sys.cpu_digits) {
            url = os.browser_download_url;
        }
    }

    // ���°汾�ļ���
    var zipName = url.split("/");
    zipName = zipName[zipName.length - 1];

    var thisExe = currentDirectory + "\\frpc.exe";
    // �����ǰĿ¼�����ļ�
    if (fso.FileExists(thisExe)) {
        // ִ�������ȥ��ִ�н���еĻ��з�
        var out = shell.Exec(cmd + thisExe + " -v").StdOut.ReadAll().replace(/\n/ig, "");
        WScript.Echo("���ص�ǰĿ¼�³���汾��", out, "\n");
        // ����Ѿ������°汾
        if (version == out) {
            return;
        }
    }

    // ���°����Ŀ¼
    var exeFolder = currentDirectory + "\\" + zipName.substring(0, zipName.length - 4);
    // �ж����°����Ŀ¼�Ƿ����
    if (fso.FolderExists(exeFolder)) {
        // �ƶ��ļ�����ǰĿ¼
        shell.Run(cmd + "move " + exeFolder + "\\frpc.exe " + currentDirectory, 0, true);
        return;
    }

    // �����ǰĿ¼����ѹ���ļ�
    if (fso.FileExists(zipName)) {
        WScript.Echo("��ǰĿ¼�������°�ѹ���ļ�����ʼ��ѹ......\n");
        decompression(cmd, shell, fso, currentDirectory, zipName, exeFolder);
        return;
    }

    WScript.Echo("��ʼ�������°����......\n");

    try {
        download(url, currentDirectory);
    } catch (e) {
        throw new Error("�����ļ�����" + e.message);
    }

    WScript.Echo("������ɣ���ʼ��ѹ......\n");

    decompression(cmd, shell, fso, currentDirectory, zipName, exeFolder);

}


/**
 * ��ѹ
 *
 * @param cmd
 * @param shell
 * @param fso
 * @param currentDirectory
 * @param zipName
 * @param exeFolder
 */
function decompression(cmd, shell, fso, currentDirectory, zipName, exeFolder) {
    zipName = currentDirectory + "\\" + zipName;
    var sp = exeFolder.split("\\");
    var exeName = " " + sp[sp.length - 1] + "\\frpc.exe ";
    download7z();
    // -aoa��ѹ�������ļ�
    shell.Run(cmd + "7za e -aoa " + zipName + exeName, 0, true);
    // ����ļ�������
    if (!fso.FileExists(currentDirectory + "\\frpc.exe")) {
        throw new Error("��ѹʧ�ܣ�");
    }
    // ɾ�����ص�zip
    fso.DeleteFile(zipName);
    WScript.Echo("��ѹ��ɣ�\n");
}

function help() {
    WScript.Echo("�����÷�:");
    WScript.Echo("   ����: " + WScript.ScriptName, " autoRun");
    WScript.Echo("     autoRun �Ƿ��������Զ����У�Ĭ��0������,1����");
}


/**
 * HTTP����
 * �鿴�������ԣ�New-Object -ComObject "WinHttp.WinHttpRequest.5.1" | Get-Member
 *
 * @param method        GET,POST
 * @param url           �����ַ
 * @param dataType      "",text,stream,xml,json
 * @param data          ���ݣ�{key:value}��ʽ
 * @param contentType   ���͵��������ͣ�multipart/form-data��
 * application/x-www-form-urlencoded��Ĭ�ϣ���text/plain
 * @returns {string|Document|any}
 */
function request(method, url, dataType, data, contentType) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("����url����Ϊ�գ�");
    }
    if (method == "" || method == null || method.length <= 0) {
        method = "GET";
    } else {
        // ���ַ���ת��Ϊ��д
        method = method.toUpperCase();
    }
    if (contentType == "" || contentType == null || contentType.length <= 0) {
        contentType = "application/x-www-form-unlenconded";
    }
    var XMLHTTPVersions = [
        'WinHttp.WinHttpRequest.5.1',
        'WinHttp.WinHttpRequest.5.0',
        'Msxml2.ServerXMLHTTP.6.0',
        'Msxml2.ServerXMLHTTP.5.0',
        'Msxml2.ServerXMLHTTP.4.0',
        'Msxml2.ServerXMLHTTP.3.0',
        'Msxml2.ServerXMLHTTP',
        'MSXML2.XMLHTTP.6.0',
        'MSXML2.XMLHTTP.5.0',
        'MSXML2.XMLHTTP.4.0',
        'MSXML2.XMLHTTP.3.0',
        'MSXML2.XMLHTTP',
        'Microsoft.XMLHTTP'
    ];
    var XMLHTTP;
    for (var i = 0; i < XMLHTTPVersions.length; i++) {
        try {
            XMLHTTP = new ActiveXObject(XMLHTTPVersions[i]);
            break;
        } catch (e) {
            WScript.Echo(XMLHTTPVersions[i] + ":", e.message);
        }
    }
    XMLHTTP.SetTimeouts(0, 1800000, 1800000, 1800000);
    //������ת����Ϊquerystring��ʽ
    var paramarray = [];
    for (key in data) {
        paramarray.push(key + "=" + data[key]);
    }
    var params = paramarray.join("&");
    switch (method) {
        case "POST":
            // 0�첽��1ͬ��
            XMLHTTP.Open(method, url, 0);
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send(params);
            break;
        default:
            // Ĭ��GET����
            if (params == "" || params.length == 0 || params == null) {
                // 0�첽��1ͬ��
                XMLHTTP.Open(method, url, 0);
            } else {
                XMLHTTP.Open(method, url + "?" + params, 0);
            }
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send();
    }
    // ���ַ���ת��ΪСд
    dataType = dataType.toLowerCase();
    switch (dataType) {
        case "text":
            return XMLHTTP.responseText;
            break;
        case "stream":
            return XMLHTTP.responseStream;
            break;
        case "json":
            return eval("(" + XMLHTTP.responseText + ")");
            break;
        default:
            return XMLHTTP.responseBody;
    }
}


/**
 * �����ļ�
 * �鿴�������ԣ�New-Object -ComObject "ADODB.Stream" | Get-Member
 *
 * @param url
 * @param directory �ļ��洢Ŀ¼
 * @param filename  �ļ�����Ϊ��Ĭ�Ͻ�ȡurl�е��ļ���
 * @returns {string}
 */
function download(url, directory, filename) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("����url����Ϊ�գ�");
    }
    if (directory == "" || directory == null || directory.length <= 0) {
        throw new Error("�ļ��洢Ŀ¼����Ϊ�գ�");
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ���Ŀ¼������
    if (!fso.FolderExists(directory)) {
        // ����Ŀ¼
        var strFolderName = fso.CreateFolder(directory);
    }
    if (filename == "" || filename == null || filename.length <= 0) {
        filename = url.substring(url.lastIndexOf("/") + 1);
        // ȥ���ļ�����������ţ�����֮ǰ�ģ��ַ�
        filename = filename.replace(/^.*(\&|\=|\?|\/)/ig, "");
    }
    var path = directory + "\\" + filename;
    var ADO = new ActiveXObject("ADODB.Stream");
    ADO.Mode = 3;
    ADO.Type = 1;
    ADO.Open();
    ADO.Write(request("GET", url, ""));
    ADO.SaveToFile(path, 2);
    ADO.Close();
    // ����ļ�������
    if (!fso.FileExists(path)) {
        throw new Error("�ļ�����ʧ��");
    }
    return path;
}


/**
 * ��ȡϵͳ��Ϣ
 *
 * @returns {{cpu_digits: *, cpu_core_number: *, system: string, os: *}}
 */
function getSystem() {
    var shell = new ActiveXObject("WScript.shell");
    var system = shell.Environment("SYSTEM");
    // ����ϵͳ
    var os = system("OS").toLowerCase().split("_")[0];
    // CPUλ��
    var cpuDigits = system("PROCESSOR_ARCHITECTURE").toLowerCase();
    // CPU������
    var cpuCoreNumber = system("NUMBER_OF_PROCESSORS");
    return {
        "os": os,
        "cpu_digits": cpuDigits,
        "cpu_core_number": cpuCoreNumber,
        "system": os + "_" + cpuDigits
    };
}


/**
 * ����7-Zip
 *
 * @param mode ����ģʽ��Ĭ��0���������أ�1��������
 */
function download7z(mode) {
    var shell = new ActiveXObject("WScript.shell");
    // ִ��7z�����ж��Ƿ����
    if (shell.Run("cmd /c 7za", 0, true) == 0 && (!mode || mode == 0)) {
        return;
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var storage = "c:\\windows";
    var exe = storage + "\\7z.exe";
    var dll = storage + "\\7z.dll";
    var filename = "";
    var reg = new RegExp("7z.*\-x64.msi", "igm");
    try {
        var url = "https://sourceforge.net/projects/sevenzip/rss?path=/7-Zip";
        filename = reg.exec(request("get", url, "text", "", ""));
    } catch (e) {
        WScript.Echo(e.message);
        var url = "https://www.7-zip.org/download.html";
        filename = reg.exec(request("get", url, "text", "", ""));
    }
    // ��ǰ�ļ�����Ŀ¼
    var dir = fso.GetFile(WScript.ScriptFullName).ParentFolder;
    var msi = dir + '\\' + filename;
    if (fso.FileExists(msi)) {
        fso.DeleteFile(msi);
    }
    var zipDir = dir + '\\7zip';
    if (fso.FolderExists(zipDir)) {
        fso.DeleteFolder(zipDir);
    }
    download("https://www.7-zip.org/a/" + filename, dir, filename);
    // ��ѹmsi�ļ�
    shell.Run('msiexec /a "' + msi + '" /qn TARGETDIR="' + zipDir + '"', 0, true);
    fso.CopyFile(dir + "\\7zip\\Files\\7-Zip\\7z.exe", exe);
    fso.CopyFile(dir + "\\7zip\\Files\\7-Zip\\7z.dll", dll);
    fso.DeleteFolder(dir + "\\7zip");
    fso.DeleteFile(msi);
    filename = filename.toString().replace("x64.msi", "extra.7z");
    var exetra = dir + '\\' + filename;
    if (fso.FileExists(exetra)) {
        fso.DeleteFile(exetra);
    }
    download("https://www.7-zip.org/a/" + filename, dir, filename);
    // -aoa��ѹ�������ļ���-o����������ֵ֮�䲻���пո�
    shell.Run('7z x -aoa "' + exetra + '" -o"' + storage + '" 7za.exe 7za.dll', 0, true);
    fso.DeleteFile(exetra);
}

/**
 * ��������
 *
 * @param mode Ϊstartupʱ���ڿ�������Ŀ¼�д���vbs�ű���������ӿ�������ע���
 */
function autoStart(mode) {
    var fileName = WScript.ScriptName;
    fileName = fileName.substring(0, fileName.lastIndexOf('.'));
    //fileName = fileName.substring(0, fileName.length-4);
    var vbsFileName = WScript.ScriptFullName.replace(".bat", ".vbs");
    if ("startup" == mode.toLowerCase()) {
        // ��������Ŀ¼
        var runDir = "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\";
        vbsFileName = runDir + fileName + ".vbs";
    } else {
        // ��ӿ�������ע���
        var shell = new ActiveXObject("WScript.shell");
        var runRegBase = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\";
        shell.RegWrite(runRegBase + fileName, vbsFileName);
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // �����ļ�
    var vbsFile = fso.CreateTextFile(vbsFileName, true);
    // ��д���ݣ������ӻ��з�
    vbsFile.WriteLine("Set shell = WScript.CreateObject(\"WScript.Shell\")");
    vbsFile.WriteLine("shell.Run \"cmd /c " + WScript.ScriptFullName + "\", 0, false");
    // �ر��ļ�
    vbsFile.Close();
}