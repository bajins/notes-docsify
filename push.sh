#!/bin/bash

project_dir=`pwd`
pd_len=${#project_dir}

# 文件列表显示到菜单栏
echo "* [files](/files.md)">nav.md
# 把根目录中的文档写入到菜单栏
for file in $(find $project_dir -maxdepth 1 -type f -name "*.md" ! -name "README*" ! -name "nav*" ! -name "files*" | sort); do
    echo >>nav.md
    # 去除/及之前的内容
    name=${file##*/}
    echo "  * [${name%.md}](${file:pd_len})">>nav.md
done

# 查找除.git、files、images以外的二级目录
for dir in $(find $project_dir -type d ! -path "*.git*" ! -path "*files*" ! -path "*images*" | sort); do
    if [ "$dir" != "$project_dir" ];then
        echo >>nav.md
        name=${dir:pd_len}
        echo "* [${name##/}](${dir:pd_len}/README.md)">>nav.md
        # 查找当前目录中除README以外的其他md文档写入到菜单栏
        for file in $(find $dir -type f -name "*.md" ! -name "README*" | sort); do
            echo >>nav.md
            # 去除/及之前的内容
            name=${file##*/}
            echo "  * [${name%.md}](${file:pd_len})">>nav.md
        done
    fi
done

# 创建文件列表文档
echo "# 文件">files.md
echo >>files.md
# 把files目录中的所有文件列出到files.md中
for file in $(find $project_dir/files -type f | sort); do
    echo "[${file##*/}](${file:pd_len} ':ignore')">>files.md
    echo >>files.md
done


git add -A