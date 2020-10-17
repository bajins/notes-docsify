# Bajins

?> 基于本仓库可快速创建你自己的动态构建（只需要编写并提交，不需要手动编译成静态HTML）文档网站。[高亮语法支持列表](https://prismjs.com/#languages-list)


## 目录结构

```
.
│  .nojekyll        用于阻止 GitHub Pages 会忽略掉下划线开头的文件
│  files.md         列出files文件夹中的文件用于下载
│  index.html       入口文件
│  nav.md           导航栏
│  README.md        首页
│  sidebar.md       侧边栏
│  push.bat         列出导航栏、侧边栏、files、提交到仓库Windows脚本
│  push.sh          列出导航栏、侧边栏、files、提交到仓库Linux或Mac脚本
│      
├─files             存放所有提供下载文件的文件夹
│      
├─images            存放所有图片文件
│  │  
│  └─icons          存放图标文件
│
...... 其他自己的md文档或文件夹

```
?> 只需遵从以上目录结构来修改你自己的文档即可使用。

!> 入口文件请结合[docsify官方文档](https://docsify.js.org)一定理解其意义再修改配置！


## 使用

- 先克隆本仓库 `git clone https://github.com/woytu/notes-docsify.git`
- 保留上面[目录结构](#目录结构)列出的文件和文件夹，其他的全部删除
- 创建自己的md文件，开始写作
- 编辑入口文件（`index.html`）：其中评论系统有多个例子，可自行修改
- Windows添加hook
    - 在项目中打开CMD执行`(echo #!/bin/bash& echo.& echo ./push.sh)>.git/hooks/pre-commit`
    - 或者`(for %i in ("#!/bin/bash" "./push.sh") do @echo %~i&@echo.)>.git/hooks/pre-commit`
    - 在PowerShell中执行<code>echo "#!/bin/bash`n./push.sh"| Out-File .git/hooks/pre-commit -encoding ASCII</code>
- Linux或Mac添加hook
    - 在项目中执行`echo -e '#!/bin/bash\n\n./push.sh'>.git/hooks/pre-commit`
    - 如果提示`-bash: !": event not found`执行`chmod +x .git/hooks/pre-commit`设置权限
- 提交（`commit`）并推送（`push`）到远程
- 提交后到GitHub设置中开启`GitHub Pages`