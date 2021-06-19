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
	echo -e "\033[34m*****************************************************\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	local localFileName=${0#*/}
	((bitNum=(49-11-${#localFileName})/2))
	if [ ${#localFileName} -lt 38 ];then
		echo -e "\033[34m**\033[0m\c"
		for((i=0;i<${bitNum};i++))
		do
			echo -e " \c"
		done
		echo -e "\033[34mWelcome to \033[0m\033[33m${localFileName}\033[0m\c"
		((bitNum=49-${bitNum}-11-${#localFileName}))
		for((i=0;i<${bitNum};i++))
		do
			echo -e " \c"
		done
		echo -e "\033[34m**\033[0m\c"
		echo
	fi
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m*****************************************************\033[0m"
	echo
	echo
}
function GetParameter()
{
    echo
    read -p "请输入URL:" URL
    echo
    Number=0
    Number=${URL##*video}
    Number=${Number%.*}
    if [ -z ${Number} ]; then
        Number=0
    fi
    if [ ${Number} -eq 0 -o -z ${URL} ];then
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""参数输入异常,程序结束!"
        exit 127
    fi
    for ((i=0;i<=${Number};i++))
    do 
        if [ ${i} -ge 0 -a ${i} -lt 10 ];then 
            array[${i}]=${URL}00${i}.ts  
        elif [ ${i} -ge 10 -a ${i} -lt 100 ];then 
            array[${i}]=${URL}0${i}.ts
        elif [ ${i} -ge 100 -a ${i} -lt 1000 ];then
            array[${i}]=${URL}${i}.ts 
        else
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""参数过大,程序结束!"
            exit 127
        fi
        echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${array[${i}]}
        echo ${array[${i}]} >> ${filename}
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
    URL=''
    #数量
    Number=0
    #目录路径
    #localDir=${HOME}/www/$(date +"%Y%m%d_%H%M%S")_URL
    localDir=${HOME}/vsftpd/$(date +"%Y%m%d_%H%M%S")_URL
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