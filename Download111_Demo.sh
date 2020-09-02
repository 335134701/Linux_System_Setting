#! /bin/bash

#**********************************************************
# 错误代码说明：
	# 0:表示正确
	# 1:表示错误
	# 60:表示软件已经安装，安装方式dpkg 
	# 80:表示实际输入参数与函数输入参数不匹配错误
	# 81:表示参数不匹配错误
	# 82:表示函数不存在错误
	# 90:表示文件不存在错误
	# 126:状态码初始位
	# 127:表示命令执行失败
#**********************************************************

function Welcome()
{
	echo
	echo
	echo
	echo -e "\033[34m*****************************************************\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	((num=26-${#0}))
	if [ ${num} -gt 0 ];then
		echo -e "\033[34m**              Welcome to \033[0m\033[33m${0#*/}\c\033[0m"
		for((i=0;i<${num};i++))
		do
			echo -e " \c"
		done
		echo -e "\033[34m**\033[0m\c"
		echo
	else
		echo -e "\033[34m**              Welcome to \033[0m\033[33m${0#*/}\033[0m"
	fi
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m*****************************************************\033[0m"
	echo
	echo
	echo
}
function GetParameter()
{
    echo
    i=0
    if [  ! -f ${localFilename} ];then
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""${localFilename} 文件不存在!"
        exit 127
    fi
    for line in `cat ${localFilename}`
    do
        result=$(echo ${line} | grep "https://")
        if [ "${result}" != "" ];then
            echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${line}
            array[${i}]=${line};
            echo ${array[${i}]} >> ${filename}
            let i=i+1;
        fi 
    done
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[34mThe method \"GetParameter()\" run success!\033[0m"
	echo 
}
function Download()
{
    echo
    localDir=${localDir}/URL
    mkdir -p ${localDir}
    echo "====================开始进行下载============================"
    for((i=0;i<=${#array[@]};i++)); do
        wget -P  ${localDir}  ${array[i]}
        if [ ${?} -eq 0 ];then
            echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${array[i]}" 下载成功!"
        else
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "${array[i]}" 下载失败!"
            echo  ${array[i]} >> ${Errorfilname}
        fi
    done
    echo "====================下载结束============================"
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[34mThe method \"Download()\" run success!\033[0m"
	echo 
}
function Main()
{
    #*************************************************************#
    #连接地址
    localFilename=${HOME}/www/us.php
    #目录路径
    localDir=${HOME}/www/$(date +"%Y%m%d_%H%M%S")_URL
    #备份文件
    filename=${localDir}/$(date +"%Y%m%d_%H%M%S")_URL.txt
    #下载失败的文件列表
    Errorfilname=${localDir}/$(date +"%Y%m%d_%H%M%S")_ErrorURL.txt
    #*************************************************************#
    Welcome
    mkdir -p ${localDir}
    GetParameter
    #Download
}
Main