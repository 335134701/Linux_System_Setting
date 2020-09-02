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
    local Url_tmp=''
    for ((i=1;i<=${Number};i++))
    do 
       for((j=1;j<=20;j++)); do
            Url_tmp=${URL}/${i}/${j}.jpg
            echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${Url_tmp}
            echo ${Url_tmp} >> ${filename} 
       done
       if [ ${i} -ne ${Number} ];then
            echo  >> ${filename}
            echo "----分界线----" >> ${filename}
            echo  >> ${filename}
       fi
       echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ==============================================="
       sleep 0.1s 
    done
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[34mThe method \"GetParameter()\" run success!\033[0m"
	echo 
}
function Download()
{
    echo
    local localURLDir=${localDir}/URL
    local number=1
    mkdir -p ${localURLDir}/${number}
    echo "====================开始进行下载============================"
    if [ -f ${filename} ]; then
        for line in $(cat ${filename})
        do
            if [ ${line} != "----分界线----" ]; then
                echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${line}
                wget -c -T 20 -w 1 -P ${localURLDir}/${number}  ${line}
                if [ ${?} -eq 0 ];then
                    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${line}" 下载成功!"
                    echo
                else
                    echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "${line}" 下载失败!"
                    echo  ${line} >> ${Errorfilname}
                    echo
                fi
            else
                $((number=number+1))
                mkdir -p ${localURLDir}/${number}
            fi   
        done
    else
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""文件：${filename} 不存在!"
    fi
    echo "====================下载结束============================"
    tar -zcxf ${localDir}/Picture.tar.gz ${localDir}/*
    if [ ${?} -eq 0 ];then
        echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""${localDir}/Picture.tar.gz 文件创建成功!"
    else
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""${localDir}/Picture.tar.gz 文件创建失败!"
    fi
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[34mThe method \"Download()\" run success!\033[0m"
	echo 
}
function Main()
{
    #*************************************************************#
    #连接地址
    URL=https://img.cache010.com/media/videos/tmb
    #数量4884
    if [ ${#} -eq 1 ];then
        Number=${1}
    else
        Number=4884
    fi
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
    Download
}
if [ ${#} -eq 1 ]; then
    Main ${1}
else
    Main
fi
#Main
