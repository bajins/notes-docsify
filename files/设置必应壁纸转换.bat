1>1/* ::
:: -------------------------------------------------------------------
::                          �Զ�����Bing��ֽ
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

var fso = new ActiveXObject("Scripting.FileSystemObject");
// ��ǰ�ļ�����Ŀ¼
var currentDirectory = fso.GetFile(WScript.ScriptFullName).ParentFolder;

if (Argv.length > 0) {
    switch (Argv(0)) {
        case "1":
            autoStart("startup");
            break;
        case "?", "help":
        default:
            help();
    }
    // �����˳�
    WScript.Quit(0);
}

var json = request("GET", "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1", "json");

var imageUrl = "https://cn.bing.com" + json.images[0].url.split("&")[0];
var imageName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1).split("=")[1];

var oldImagePath = download(imageUrl, currentDirectory, imageName);
// ���ת�����ļ�������
if (!fso.FileExists(oldImagePath)) {
    WScript.Echo("ͼƬ����ʧ��");
    WScript.Quit(1);
}
var imagePath = imageTransform(oldImagePath, "bmp");
if (fso.FileExists(imagePath)) {
    setWallpaper(imagePath);
    WScript.Sleep(5000);
    fso.DeleteFile(imagePath);
    fso.DeleteFile(oldImagePath);
    WScript.Echo("���ñ�ֽ�ɹ���", imagePath);
    WScript.Quit(0);
} else {
    WScript.Echo("���ر�ֽʧ�ܣ�");
    WScript.Quit(1);
}


function help() {
    WScript.Echo("�����÷�:");
    WScript.Echo("   " + WScript.ScriptName, "autoRun");
    WScript.Echo("      autoRun �Ƿ��������Զ����У�Ĭ��0������,1����");
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
 * ͼƬ��ʽת��
 *
 * @param imagePath ԭʼͼƬȫ·��
 * @param format    Ҫת���ĸ�ʽ����׺��
 * @returns {string}
 */
function imageTransform(imagePath, format) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ����ļ�������,��˵��û��ת���ɹ�
    if (!fso.FileExists(imagePath)) {
        throw new Error("ͼƬ�����ڻ�·������");
    }
    // ת�����ʽ�ļ�ȫ·��
    var formatPath = imagePath.replace(/(.+)\.[^\.]+$/, "$1") + "." + format;
    // ���ת�����ļ��Ѵ���
    if (fso.FileExists(formatPath)) {
        throw new Error("Ҫת���ĸ�ʽ�ļ��Ѿ����ڣ�");
    }
    // תСд
    format = format.toLowerCase();
    var wiaFormat = "";
    switch (format) {
        case "bmp":
            wiaFormat = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "png":
            wiaFormat = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "gif":
            wiaFormat = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}";
            break;
        case "tiff":
            wiaFormat = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}";
            break;
        default:
            // Ĭ��JPEG
            wiaFormat = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}";
    }
    var img = new ActiveXObject("WIA.ImageFile");
    img.LoadFile(imagePath);
    var imgps = new ActiveXObject("WIA.ImageProcess");
    imgps.Filters.Add(imgps.FilterInfos("Convert").FilterID);
    // ת����ʽ
    imgps.Filters(1).Properties("FormatID").Value = wiaFormat;
    // ͼƬ����
    //imgps.Filters(1).Properties("Quality").Value = 5
    imgps.Apply(img).SaveFile(formatPath);
    // ����ļ�������,��˵��û��ת���ɹ�
    if (!fso.FileExists(formatPath)) {
        throw new Error("ͼƬ��ʽתΪ" + format + "ʧ��");
    }
    return formatPath;
}

/**
 * ���������ֽ
 *
 * @param imagesPath ͼƬȫ·��
 */
function setWallpaper(imagesPath) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // ����ļ�������,��˵��û��ת���ɹ�
    if (!fso.FileExists(imagePath)) {
        throw new Error("ͼƬ�����ڻ�·������");
    }
    var shell = new ActiveXObject("WScript.shell");
    // HKEY_CURRENT_USER
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\TileWallpaper", "0");
    // ���ñ�ֽȫ·��
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\Wallpaper", imagesPath);
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\WallpaperStyle", "2", "REG_DWORD");
    var shadowReg = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion";
    shell.RegWrite(shadowReg + "\\Explorer\\Advanced\\ListviewShadow", "1", "REG_DWORD");
    // �������ͼ��δ͸������Ҫˢ�������
    //shell.Run("gpupdate /force", 0, true);
    // �����Ѿ�ͨ��ע��������˱�ֽ�Ĳ���������Windows api SystemParametersInfoˢ������
    var spi = "RunDll32 USER32,SystemParametersInfo SPI_SETDESKWALLPAPER 0 \"";
    shell.Run(spi + imagesPath + "\" SPIF_SENDWININICHANGE+SPIF_UPDATEINIFILE", 0, true);
    // for (var i = 0; i < 30; i++) {
    //     // ʵʱˢ������
    //     shell.Run("RunDll32 USER32,UpdatePerUserSystemParameters", 0, true);
    // }
    shell.Run("regsvr32.exe /s /n /i:/UserInstall %SystemRoot%\\system32\\themeui.dll", 0, true);
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
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        // �����ļ�
        var vbsFile = fso.CreateTextFile(vbsFileName, true);
        // ��д���ݣ������ӻ��з�
        vbsFile.WriteLine("Set shell = WScript.CreateObject(\"WScript.Shell\")");
        vbsFile.WriteLine("shell.Run \"cmd /c " + WScript.ScriptFullName + "\", 0, false");
        // �ر��ļ�
        vbsFile.Close();

        createSchedule("SetBingWallpaper", "���ñ�Ӧ��ֽ", "bajins", "wscript", '"' + vbsFileName + '"');
    } else {
        // ��ӿ�������ע���
        var shell = new ActiveXObject("WScript.shell");
        var runRegBase = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\";
        shell.RegWrite(runRegBase + fileName, vbsFileName);
    }
}

/**
 * ��������ƻ�
 *
 * @param name ����ƻ���
 * @param desc ����ƻ�����
 * @param author ����ƻ�������
 * @param path ִ�еĳ����ű�·��
 * @param arguments ��ִ�еĳ����ű�����������Ĳ���
 */
function createSchedule(name, desc, author, path, arguments) {
    // ����TaskService�����ṩ������ƻ��������ķ���Ȩ�ޣ��Թ�����ע�������
    var service = new ActiveXObject("Schedule.Service");
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/taskservice-connect
    service.Connect();

    // ��ȡһ���ļ����������д��������塣
    var rootFolder = service.GetFolder("\\");
    // ����һ���յ���������󣬲�������������ʹ�ã���������Ϊ0
    var taskDefinition = service.NewTask(0);

    // ����RegistrationInfo�������������ע����Ϣ
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/registrationinfo
    var regInfo = taskDefinition.RegistrationInfo;
    // ����˵��
    regInfo.Description = desc;
    // ������
    regInfo.Author = author;

    // �������ϣ����г���/�ű��ȶ����ļ��ϣ����32������
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/actioncollection
    var actions = taskDefinition.Actions;
    // ����Ҫִ�е�����Ķ�����0���нű������5�����������6�����ʼ���7��ʾһ����Ϣ��
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/actioncollection-create
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/action#remarks
    
    // ��������Ӳ��� https://docs.microsoft.com/zh-cn/windows/win32/taskschd/execaction
    var action = actions.Create(0);
    // ��������Ӳ���
    action.Path = path;
    // �����ʵ�����ݲ���
    action.Arguments = arguments;

    // �ṩ���尲ȫ֤��Ľű�������Щ��ȫƾ֤Ϊ��ί���˹������������˰�ȫ�����ġ�
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/principal
    var principal = taskDefinition.Principal;
    // ����¼��������Ϊ����ʽ��¼
    // principal.LogonType = 3;
    // ��ȡ�����ñ�ʶ�����ñ�ʶ������ָ������������������������������Ȩ����
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/principal-runlevel
    principal.RunLevel = 1;

    // ����һ��TaskSettings������������ƻ����������������Ϣ
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/tasksettings
    var settings = taskDefinition.Settings;
    // ��ֵָʾ����ƻ���������ڼƻ�ʱ���ȥ֮����κ�ʱ����������
    settings.StartWhenAvailable = true;
    settings.Enabled = true;
    settings.Hidden = false;

    // ��ȡ������������������Ĵ������ļ��ϡ�
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/trigger
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/triggercollection-create
    var triggers = taskDefinition.Triggers;
    // �����¼�������
    // https://docs.microsoft.com/en-us/previous-versions//aa446887(v=vs.85)
    var trigger = triggers.Create(0);
    // �����¼���ѯ�����������������񣬵��յ��¼�ʱ��
    trigger.Subscription = "<QueryList>" +
        "<Query Id='0'><Select Path='System'>" +
        "*[System[Provider[@Name='Microsoft-Windows-Power-Troubleshooter'] and EventID=1]]" +
        "</Select></Query>" +
        "<Query Id='1'><Select Path='System'>" +
        "*[System/Level=2]" +
        "</Select></Query>" +
        "</QueryList>";
    // �������ô������ڷ����������ʱ��������Ĵ�����
    //triggers.Create(6);
    // ����ע�ᴥ����
    triggers.Create(7);
    // ��������������
    triggers.Create(8);
    // ������¼������
    triggers.Create(9);
    // ���ڴ�������̨���ӻ�Ͽ����ӣ�Զ�����ӻ�Ͽ����ӻ���վ���������֪ͨ������
    var trigger11 = triggers.Create(11);
    // ��ȡ�����ý����������������ն˷������Ự���ĵ����ͣ�7������8����
    trigger11.StateChange = 8;

    // ʹ��ITaskDefinition�ӿ���ָ��λ��ע�ᣨ�����������Զ�������
    // �û�ID�У�Local Service ; SYSTEM ; nullΪ��ǰ��¼���û���
    // ���һλ����Ӱ������ƻ�����
    // https://docs.microsoft.com/zh-cn/windows/win32/taskschd/taskfolder-registertaskdefinition
    rootFolder.RegisterTaskDefinition(name, taskDefinition, 6, null, null, 3);
}