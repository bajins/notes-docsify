#!/bin/bash

if [! -n "$1"] then
    help;
    exit;
fi


function help(){
    echo "错误请输入本次提交到仓库的备注信息！";
    echo "基本用法：";
    echo    "push commit-info";
    echo    "commit-info：本次提交到仓库的备注信息";
}