1>1/* ::
:: -------------------------------------------------------------------
::                          �Զ�����GitHubHosts
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

:: �����ӳٻ���������չ
:: ���for��if�в�������ʱ��ʾECHO OFF���⣬��!!ȡ����
:: �������jscript��ʾ�����������
setlocal enabledelayedexpansion

if "%~1"=="/?" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)
if "%~1"=="/help" (
    cscript -nologo -e:jscript "%~f0" help
    goto :EXIT
)

:: cscript -nologo -e:jscript "%~f0" ��һ����ִ�����������ǲ�������ɷ�ʽ��/key:value��
:: %~f0 ��ʾ��ǰ������ľ���·��,ȥ�����ŵ�����·��
cscript -nologo -e:jscript "%~f0" %~1


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

if (Argv.length > 0) {
    switch (Argv(0)) {
        case "1":
            autoStart("startup");
            break;
        case "?", "help":
        default:
            WScript.Echo("˫��ִ�м��ɣ�");
    }
    // �����˳�
    WScript.Quit(0);
}

var fso = new ActiveXObject("Scripting.FileSystemObject");
// ��ǰ�ļ�����Ŀ¼
var currentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder;

var hostsPath = "C:\\Windows\\System32\\drivers\\etc\\hosts";

var hostsObject = fso.OpenTextFile(hostsPath, 1);
var hosts = hostsObject.ReadAll();
hostsObject.Close();
var hostsArray = hosts.split(/[\r\n]/);

var githubDomain = [
    "assets-cdn.github.com",
    "avatars.githubusercontent.com",
    "avatars0.githubusercontent.com",
    "avatars1.githubusercontent.com",
    "codeload.github.com",
    "documentcloud.github.com",
    "gist.github.com",
    "github.com",
    "github.global.ssl.fastly.net",
    "github.io",
    "github-cloud.s3.amazonaws.com",
    "global-ssl.fastly.net",
    "help.github.com",
    "nodeload.github.com",
    "raw.github.com",
    "status.github.com",
    "training.github.com",
    "www.github.com",
    "raw.githubusercontent.com"
]


var newHosts = [];

for (var i = 0; i < hostsArray.length; i++) {
    if (!isInArray(githubDomain, hostsArray[i])) {
        newHosts.push(hostsArray[i]);
    }
}

for (var i = 0; i < githubDomain.length; i++) {
    var data = { "qtype": 1, "host": githubDomain[i], "qmode": -1 };
    var url = "https://myssl.com/api/v1/tools/dns_query";
    var json = request("GET", url, "json", data, null);
    if (json.code == 0 && (json.error == null || json.error == "")) {
        var resultData = json.data;
        var addrUs = resultData["01"][0]["answer"]["records"];
        if (addrUs == null) {
            continue;
        }
        //var addrHk = resultData["852"][0].answer.records;
        //var addrCn = resultData["86"][0].answer.records;
        for (var j = 0; j < addrUs.length; j++) {
            newHosts.push(addrUs[j]["value"] + " " + githubDomain[i]);
        }
    }
}

// for (var i = 0; i < githubDomain.length; i++) {
//     var data = { "server": "8.8.8.8", "rrtype": "A", "domain": githubDomain[i] };
//     var url = "https://shorttimemail.com/net/dns/query";
//     var json = request("GET", url, "json", data, null);
//     if (json.code == 0 && json.msg == "ok") {
//         var resultData = json.data;
//         if (resultData.length == 0) {
//             continue;
//         }
//         for (var j = 0; j < resultData.length; j++) {
//             newHosts.push(resultData[j] + " " + githubDomain[i]);
//         }
//     }
// }

// for (var i = 0; i < githubDomain.length; i++) {
//     // ��ȡtoken
//     var html = request("GET", "http://tool.chinaz.com/dns?type=1&host=" + githubDomain[i], "text", null, null);
//     var servers = new RegExp("var servers = (.*)", "ig").exec(html);
//     var sjson = eval("(" + servers + ")");
//     for (var j = 0; j < sjson.length; j++) {
//         // ��ȡDNS
//         var data = { "host": githubDomain[i], "type": 1, "total": 10, "process": 0, "right": 0 };
//         var url = "http://tool.chinaz.com/AjaxSeo.aspx?t=dns&server=" + sjson.ip + "&id=" + sjson.id;
//         var dnsJson = eval(request("POST", url, "text", data, null));
//         for (var k = 0; k < dnsJson.list.length; k++) {
//             newHosts.push(dnsJson.list[k].result + " " + githubDomain[i]);
//         }
//     }
// }

// for (var i = 0; i < githubDomain.length; i++) {
//     // ��ȡtoken
//     var member = request("GET", "https://www.dns.com/member", "json", null, null);
//     if (member.code == 1 && msg == "") {
//         // ��ȡIP��host
//         var getIp = request("POST", "https://www.dns.com/getIp?_token=" + member.data.tk, "json", null, null);
//         if (getIp.code == 1) {
//             // ��ѯDNS
//             var data = { "host": getIp.data.host, "url": githubDomain[i], "_token": member.data.tk };
//             var getDns = request("POST", "https://www.dns.com/getDns", "json", data, null);
//             if (getDns.code == 1) {
//                 for (var j = 0; j < resultData.length; j++) {
//                     newHosts.push(getDns.data.userip + " " + githubDomain[i]);
//                 }
//             }
//         }
//     }
// }

// https://www.boce.com/tool

// https://tools.ipip.net/dns.php

hostsObject = fso.OpenTextFile(hostsPath, 2, true);
hostsObject.Write(newHosts.join("\r\n"));

var shell = new ActiveXObject("WScript.shell");
shell.Run("ipconfig /flushdns", 0, true);


/**
 * �ж��������Ƿ����ָ���ַ���
 *
 * @param arr
 * @param obj
 * @returns {boolean}
 */
function isInArray(arr, obj) {
    var i = arr.length;
    while (i--) {
        if (obj.match(RegExp("^.*" + arr[i] + ".*"))) {
            return true;
        }
    }
    return false;
}

function help() {
    WScript.Echo("�����÷�:");
    WScript.Echo("   " + WScript.ScriptName, "autoRun");
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