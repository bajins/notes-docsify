# WindowsJScript


[[toc]]



## flag

* [https://www.wanweibaike.com/wiki-JScript](https://www.wanweibaike.com/wiki-JScript)


> `JScript`实现的`ECMAScript Edition 3`，也是`IE8`使用的引擎。然而，随着`V8`大放光彩，
> 微软放弃了之前规划的托管`JavaScript`计划（同期规划的`VB`变身为`VB.NET`活了下来），
> `JScript`开发组另起炉灶搞了`Chakra`与`Node.js`一争长短，这也是`IE9`之后使用的`JS`引擎。

> 在`JScript`中，永远不需要去实例化根对象`WScript`，正如同浏览器中的直接全局对象一样。

**`BAT`执行`JScript`原理**

> 把`batch`命令用`JavaScript`注释`/**/`包裹住，然后用`batch`命令执行文件中的`JavaScript`代码时就不会编译`batch`命令了
>> `1>1/* ::` 表示文件和`batch`命令的开头
>>
>> `*/` 表示`batch`命令的结尾

> 执行当前脚本中的JavaScript脚本：`cscript -nologo -e:jscript "%~f0"`，`%~f0`表示当前批处理的绝对路径,去掉引号的完整路径

* [JScript (ECMAScript3)](https://docs.microsoft.com/zh-cn/previous-versions//hbxc2t98(v=vs.85))
* [JScript参考手册](https://www.php.cn/manual/view/14969.html)
* [JScript](https://www.itminus.com/blog/categories/%E9%A3%8E%E8%AF%AD/ECMAScript/JScript)
* [http://caibaojian.com/jscript](http://caibaojian.com/jscript)


## ActiveXObject

* [ActiveXObject](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Microsoft_Extensions/ActiveXObject)
* [ActiveXObject对象使用整理](https://blog.csdn.net/chen_zw/article/details/9336375)

- `JScript`中`ActiveXObject`对象是启用并返回`Automation`对象的引用。

> 使用方法：`var newObj = new ActiveXObject( servername.typename[, location])`
>> 其中`newObj`是必选项。要赋值为`ActiveXObject`的变量名。
>>
>> `servername`是必选项。提供该对象的应用程序的名称。
>>
>> `typename`是必选项。要创建的对象的类型或类。
>>
>> `location`是可选项。创建该对象的网络服务器的名称。



## 参数传递

```batch
1>1/* ::
::  by bajins https://www.bajins.com

@echo off
md "%~dp0$testAdmin$" 2>nul
if not exist "%~dp0$testAdmin$" (
    echo 不具备所在目录的写入权限! >&2
    exit /b 1
) else rd "%~dp0$testAdmin$"

:: 开启延迟环境变量扩展
:: 解决for或if中操作变量时提示ECHO OFF问题，用!!取变量
:: 解决调用jscript提示命令错误问题
setlocal enabledelayedexpansion

:: %~f0 表示当前批处理的绝对路径,去掉引号的完整路径，后面的是参数（组成方式：/key:value）
cscript -nologo -e:jscript "%~f0" /func:download /url:%~1 /path:%~2

:: 无键，直接传入值
cscript -nologo -e:jscript "%~f0" download %~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9
goto :EXIT

:EXIT
:: 结束延迟环境变量扩展和命令执行
endlocal&exit /b %errorlevel%
*/

// ****************************  JavaScript  *******************************

// 传参时指定键值，组成方式：/key:value
var Argv = WScript.Arguments;
for (i = 0; i < Argv.Length; i++) {
    info("参数：" + Argv(i));
}
var ArgvName = Argv.Named;
var func = ArgvName.Item("func");
var path = ArgvName.Item("path");

// 无键，直接传入值
var Argv = WScript.Arguments;
for (i = 0; i < Argv.Length; i++) {
    info("参数：" + Argv(i));
}
var func = Argv(0);
var url = Argv(1);
var path = Argv(2);

```


## js函数封装

### HTTP请求

```js
/**
 * HTTP请求
 * 查看方法属性：New-Object -ComObject "WinHttp.WinHttpRequest.5.1" | Get-Member
 *
 * @param method        GET,POST
 * @param url           请求地址
 * @param dataType      "",text,stream,xml,json
 * @param data          数据，{key:value}格式
 * @param contentType   发送的数据类型：multipart/form-data、
 * application/x-www-form-urlencoded（默认）、text/plain
 * @returns {string|Document|any}
 */
function request(method, url, dataType, data, contentType) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("请求url不能为空！");
    }
    if (method == "" || method == null || method.length <= 0) {
        method = "GET";
    } else {
        // 把字符串转换为大写
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
    //将对象转化成为querystring形式
    var paramarray = [];
    for (key in data) {
        paramarray.push(key + "=" + data[key]);
    }
    var params = paramarray.join("&");
    switch (method) {
        case "POST":
            // 0异步、1同步
            XMLHTTP.Open(method, url, 0);
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send(params);
            break;
        default:
            // 默认GET请求
            if (params == "" || params.length == 0 || params == null) {
                // 0异步、1同步
                XMLHTTP.Open(method, url, 0);
            } else {
                XMLHTTP.Open(method, url + "?" + params, 0);
            }
            XMLHTTP.SetRequestHeader("CONTENT-TYPE", contentType);
            XMLHTTP.Send();
    }
    // 把字符串转换为小写
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
 * 下载文件
 * 查看方法属性：New-Object -ComObject "ADODB.Stream" | Get-Member
 *
 * @param url
 * @param directory 文件存储目录
 * @param filename  文件名，为空默认截取url中的文件名
 * @returns {string}
 */
function download(url, directory, filename) {
    if (url == "" || url == null || url.length <= 0) {
        throw new Error("请求url不能为空！");
    }
    if (directory == "" || directory == null || directory.length <= 0) {
        throw new Error("文件存储目录不能为空！");
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // 如果目录不存在
    if (!fso.FolderExists(directory)) {
        // 创建目录
        var strFolderName = fso.CreateFolder(directory);
    }
    if (filename == "" || filename == null || filename.length <= 0) {
        filename = url.substring(url.lastIndexOf("/") + 1);
        // 去掉文件名的特殊符号（包括之前的）字符
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
    // 如果文件不存在
    if (!fso.FileExists(path)) {
        throw new Error("文件下载失败");
    }
    return path;
}
```


### 解析XML

```js
/**
 * 解析XML
 * 查看方法属性：New-Object -ComObject "Msxml2.DOMDocument.6.0" | Get-Member
 *
 * @param xml xml字符串或者文件路径
 * @returns {*}
 * @constructor
 */
function XMLParsing(xml) {
    if (xml == "" || xml == null || xml.length <= 0) {
        throw new Error("xml字符串或者文件路径不能为空！");
    }
    var xmlDomVersions = [
        'Msxml2.DOMDocument.6.0',
        'Msxml2.DOMDocument.5.0',
        'Msxml2.DOMDocument.4.0',
        'MSXML2.DOMDocument.3.0',
        'MSXML2.DOMDocument',
        'Microsoft.XMLDOM'
    ];
    var xmlParser;
    for (var i = 0; i < xmlDomVersions.length; i++) {
        try {
            xmlParser = new ActiveXObject(xmlDomVersions[i]);
            break;
        } catch (e) {
            WScript.Echo(XMLHTTPVersions[i] + ":",  e.message);
        }
    }
    xmlParser.async = false;
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FileExists(xml)) {
        // 载入xml字符串
        xmlParser.loadXML(xml);
    }else {
        // 载入xml文件
        xmlParser.load(xml);
    }
    return xmlParser;
}
```



### 解析HTML

```js
/**
 * 解析HTML
 * 查看方法属性：New-Object -ComObject "htmlfile" | Get-Member
 *
 * @param html html字符串或者文件路径
 * @returns {any}
 * @constructor
 */
function HtmlParsing(html) {
    if (html == "" || html == null || html.length <= 0) {
        throw new Error("html字符串或者文件路径不能为空！");
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (fso.FileExists(html)) {
        var htmlFile = fso.OpenTextFile(html, ForReading);
        html = htmlFile.ReadAll;
        htmlFile.Close();
    }
    // mhtmlfile
    var htmlParser = new ActiveXObject("htmlfile");
    htmlParser.designMode = "on";
    htmlParser.write(html);
    return htmlParser;
}
```




### 图片格式转换

```js
/**
 * 图片格式转换
 *
 * @param imagePath 原始图片全路径
 * @param format    要转换的格式，后缀名
 * @returns {string}
 */
function imageTransform(imagePath, format) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // 如果文件不存在,就说明没有转换成功
    if (!fso.FileExists(imagePath)) {
        throw new Error("图片不存在或路径错误！");
    }
    // 转换后格式文件全路径
    var formatPath = imagePath.replace(/(.+)\.[^\.]+$/, "$1") + "." + format;
    // 如果转换后文件已存在
    if (fso.FileExists(formatPath)) {
        throw new Error("要转换的格式文件已经存在！");
    }
    // 转小写
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
            // 默认JPEG
            wiaFormat = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}";
    }
    var img = new ActiveXObject("WIA.ImageFile");
    img.LoadFile(imagePath);
    var imgps = new ActiveXObject("WIA.ImageProcess");
    imgps.Filters.Add(imgps.FilterInfos("Convert").FilterID);
    // 转换格式
    imgps.Filters(1).Properties("FormatID").Value = wiaFormat;
    // 图片质量
    //imgps.Filters(1).Properties("Quality").Value = 5
    imgps.Apply(img).SaveFile(formatPath);
    // 如果文件不存在,就说明没有转换成功
    if (!fso.FileExists(formatPath)) {
        throw new Error("图片格式转为" + format + "失败");
    }
    return formatPath;
}
```

### 设置壁纸

```js
/**
 * 设置桌面壁纸
 *
 * @param imagesPath 图片全路径
 */
function setWallpaper(imagesPath) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // 如果文件不存在,就说明没有转换成功
    if (!fso.FileExists(imagePath)) {
        throw new Error("图片不存在或路径错误！");
    }
    var shell = new ActiveXObject("WScript.shell");
    // HKEY_CURRENT_USER
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\TileWallpaper", "0");
    // 设置壁纸全路径
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\Wallpaper", imagesPath);
    shell.RegWrite("HKCU\\Control Panel\\Desktop\\WallpaperStyle", "2", "REG_DWORD");
    var shadowReg = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion";
    shell.RegWrite(shadowReg + "\\Explorer\\Advanced\\ListviewShadow", "1", "REG_DWORD");
    // 如果桌面图标未透明，需要刷新组策略
    //shell.Run("gpupdate /force", 0);
    // 上面已经通过注册表设置了壁纸的参数，调用Windows api SystemParametersInfo刷新配置
    var spi = "RunDll32 USER32,SystemParametersInfo SPI_SETDESKWALLPAPER 0 \"";
    shell.Run(spi + imagesPath + "\" SPIF_SENDWININICHANGE+SPIF_UPDATEINIFILE");
    for (var i = 0; i < 30; i++) {
        // 实时刷新桌面
        shell.Run("RunDll32 USER32,UpdatePerUserSystemParameters");
    }
}
```

### 获取系统信息

```js
/**
 * 获取系统信息
 * 
 * @returns {{cpu_digits: *, cpu_core_number: *, system: string, os: *}}
 */
function getSystem() {
    var shell = new ActiveXObject("WScript.shell");
    var system = shell.Environment("SYSTEM");
    // 操作系统
    var os = system("OS").toLowerCase().split("_")[0];
    // CPU位数
    var cpuDigits = system("PROCESSOR_ARCHITECTURE").toLowerCase();
    // CPU核心数
    var cpuCoreNumber = system("NUMBER_OF_PROCESSORS");
    return {
        "os": os,
        "cpu_digits": cpuDigits,
        "cpu_core_number": cpuCoreNumber,
        "system": os + "_" + cpuDigits
    };
}
```

```js
/**
 * 获取当前系统位数
 * 
 * @returns {string}
 */
function systemDigits() {
    var locator = new ActiveXObject("WbemScripting.SWbemLocator");
    // 连接本地电脑
    var service = locator.ConnectServer(".");
    // 获取系统版本
    var csResult = service.ExecQuery("Select * from Win32_ComputerSystem");
    // 创建一个可枚举的对象
    var cs = new Enumerator(csResult).item();
    var digits = cs.SystemType;
    if (digits.indexOf("86") != -1) {
        return "i386";
    } else if (digits.indexOf("64") != -1) {
        return "amd64";
    }
    wscript.echo("不知道32位还是64位的");
    wscript.quit(1);
}

/**
 * 获取当前系统版本
 * 
 * @returns {string}
 */
function osVersion() {
    var locator = new ActiveXObject("WbemScripting.SWbemLocator");
    // 连接本地电脑
    var service = locator.ConnectServer(".");
    // 获取系统版本
    var osResult = service.ExecQuery("Select * from Win32_OperatingSystem");
    // 创建一个可枚举的对象
    var os = new Enumerator(osResult).item();
    var caption = os.Caption;
    // 截取version最后一个"."的左面部分
    var version = os.Version.substring(0, version.lastIndexOf("."));
    switch (version) {
        case "5.2":
            return "Windows Server 2003";
            break;
        case "5.0":
            return "Windows 2000";
            break;
        case "5.1":
            return "Windows XP";
            break;
        case "6.0":
            return "windows visita";
            break;
        case "6.1":
            return "windows 7";
            break;
        case "10.0":
            return "windows 10";
            break;
        defult:
            return version;
    }
}
```



### 解压zip

```js
/**
 * 解压zip
 * 查看方法属性：New-Object -ComObject "Shell.Application" | Get-Member
 * 
 * @param zipFile       zip文件全路径
 * @param unDirectory   解压目录
 */
function unZip(zipFile, unDirectory) {
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if (!fso.FileExists(zipFile)) {
        throw new Error("压缩文件不存在！");
    }
    if (fso.GetExtensionName(zipFile) != "zip") {
        throw new Error("压缩文件后缀不为zip！");
    }
    // 如果解压目录不存在
    if (!fso.FolderExists(unDirectory)){
        // 创建目录
        fso.CreateFolder(unDirectory);
    }
    var objShell = new ActiveXObject("Shell.Application");
    var objSource = objShell.NameSpace(zipFile);
    if (objSource == null) {
        throw new Error("无法解压文件！");
    }
    objShell.NameSpace(unDirectory).CopyHere(objSource.Items(), 256);
}
```



### 下载7z

```js
/**
 * 下载7-Zip
 *
 * @param mode 下载模式：默认0不覆盖下载，1覆盖下载
 */
function download7z(mode) {
    var shell = new ActiveXObject("WScript.shell");
    // 执行7z命令判断是否存在
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
    // 当前文件所在目录
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
    // 解压msi文件
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
    // -aoa解压并覆盖文件，-o参数必须与值之间不能有空格
    shell.Run('7z x -aoa "' + exetra + '" -o"' + storage + '" 7za.exe 7za.dll', 0, true);
    fso.DeleteFile(exetra);
}
```



### 数据库

```js
/**
 * 数据库
 * 查看方法属性：New-Object -ComObject "ADODB.Connection" | Get-Member
 */
function db(){
    // 创建数据库对象   
    var objdbConn = new ActiveXObject("ADODB.Connection");
    var strdsn = "Driver={SQL Server}; Server=(local); Database=Test;UID=sa;PWD=123456";
    // 打开数据源   
    objdbConn.Open(strdsn);
    // 执行SQL的数据库查询   
    var objrs = objdbConn.Execute("Select * from test");
    // 获取字段数目   
    var fdCount = objrs.Fields.Count - 1;
    // 显示数据库内容   
    while (!objrs.EOF) {
        // 显示每笔记录的字段
        for (i = 0; i <= fdCount; i++){
            WScript.Echo(objrs.Fields(i).Value);
        }
        // 移到下一笔记录
        objrs.moveNext();
    }
    // 关闭记录集合
    objrs.Close();
    // 关闭数据库链接
    objdbConn.Close();
}
```


### 开机启动

```js
/**
 * 开机启动
 *
 * @param mode 为startup时是在开机启动目录中创建vbs脚本，否则添加开机启动注册表
 */
function autoStart(mode) {
    var fileName = WScript.ScriptName;
    fileName = fileName.substring(0, fileName.lastIndexOf('.'));
    //fileName = fileName.substring(0, fileName.length-4);
    var vbsFileName = WScript.ScriptFullName.replace(".bat", ".vbs");
    if ("startup" == mode.toLowerCase()) {
        // 开机启动目录
        var runDir = "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\";
        vbsFileName = runDir + fileName + ".vbs";
    } else {
        // 添加开机启动注册表
        var shell = new ActiveXObject("WScript.shell");
        var runRegBase = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\";
        shell.RegWrite(runRegBase + fileName, vbsFileName);
    }
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    // 创建文件
    var vbsFile = fso.CreateTextFile(vbsFileName, true);
    // 填写数据，并增加换行符
    vbsFile.WriteLine("Set shell = WScript.CreateObject(\"WScript.Shell\")");
    vbsFile.WriteLine("shell.Run \"cmd /c " + WScript.ScriptFullName + "\", 0, false");
    // 关闭文件
    vbsFile.Close();
}
```

### 获取所有COM组件

```js
// 列举本机所有的 com 组件 by http://www.bathome.net/thread-32948-1-1.html
function listcom() {
    var dict = new ActiveXObject('Scripting.Dictionary');
    var oLoc = new ActiveXObject("WbemScripting.SWbemLocator");

    var oReg = oLoc.ConnectServer(null, "root\\default").Get("StdRegProv");
    var oMethod = oReg.Methods_("EnumKey");
    var oInParam = oMethod.InParameters.SpawnInstance_();
    oInParam.hDefKey = 0x80000000;
    oInParam.sSubKeyName = '';
    var NameAndType = oReg.ExecMethod_(oMethod.Name, oInParam);
    var arrSubKeys = NameAndType.sNames.toArray();

    // 遍历HKEY_CLASSES_ROOT中所有键
    for (var i = 0; i < arrSubKeys.length; i++) {
        var key = arrSubKeys[i];
        if (key.search(/..\./) < 0) {
            continue;
        }
        if (key.search(/..\..*\./) > 0) {
            var independent = key.replace(/.+?$/, '');
            if (!dict.Exists(independent)) {
                dict.Add(key, 0);
            }
        } else {
            var vdpid = "";
            for (var element in dict) {
                if (element.length > key.length && element.substring(key.length) == key + ".") {
                        vdpid = element;
                        break;
                }
            }
            if (vdpid.length) {
                dict.Remove(vdpid);
            }
            dict.Add(key, '');
        }
    }
    var retArr = [];
    var arr = new VBArray(dict.Keys()).toArray();
    for (var i = 0; i < arr.length; i++) {
        retArr.push(arr[i]);
    }
    return retArr;
}
var fso = new ActiveXObject('Scripting.FileSystemObject');
var ts = fso.CreateTextFile('本机可用的com组件.txt', true);
ts.Write(listcom().join('\r\n'));
```