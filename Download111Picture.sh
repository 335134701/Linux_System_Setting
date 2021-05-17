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
    local Url_tmp=''
    for ((i=${Startnumber};i<=${Endnumber};i++))
    do 
       for((j=1;j<=20;j++)); do
            Url_tmp=${URL}/${i}/${j}.jpg
            echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${Url_tmp}
            echo ${Url_tmp} >> ${filename} 
       done
       if [ ${i} -ne ${Endnumber} ];then
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
    local number=${Startnumber}
    mkdir -p ${localURLDir}/${number}
    echo "====================开始进行下载============================"
    if [ -f ${filename} ]; then
        for line in $(cat ${filename})
        do
            if [ ${line} != "----分界线----" ]; then
                echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${line}
                wget -nv -c -T 20 -t 5 -w 1 -P ${localURLDir}/${number}  ${line}
                if [ ${?} -eq 0 ];then
                    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "${line}" 下载成功!"
                    echo
                else
                    echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "${line}" 下载失败!"
                    echo  ${line} >> ${Errorfilname}
                    echo
                fi
            else
                number=$[ ${number}+1 ]
                mkdir -p ${localURLDir}/${number}
            fi   
        done
    else
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""文件：${filename} 不存在!"
    fi
    echo "====================下载结束============================"
    echo
    tar --warning=no-file-changed -zcvf ${localDir}/${localDir##*/}_Picture.tar.gz ${localDir}/* >/dev/null 2>&1
    if [ ${?} -eq 0 ];then
        echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""${localDir}/${localDir##*/}_Picture.tar.gz 文件创建成功!"
    else
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""${localDir}/${localDir##*/}_Picture.tar.gz 文件创建失败!"
    fi
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[34mThe method \"Download()\" run success!\033[0m"
	echo 
}
function Main()
{
    #*************************************************************#
    #连接地址
    URL=https://img.cache010.com/media/videos/tmb
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
#数量4884
#开头数目
Startnumber=1
#结尾数目
Endnumber=4884
while getopts "s:e:v" arg
do
    case "${arg}" in
        s)
            Startnumber=${OPTARG}
            echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""根据输入，将从 ${Startnumber} 处开始下载!"
        ;;
        e)
            if [ ${OPTARG} -ge ${Startnumber} ]; then
                Endnumber=${OPTARG}
                echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""根据输入，将从 ${Endnumber} 处结束下载!"
            else
                echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""输入数字小于开始数字，将采取默认结束位置进行下载"  
            fi
        ;;
        v)
            echo -e "[\033[33m$(date +"%Y-%m-%d %T") Warn\033[0m]  ""此字符操作无效,默认从 ${Startnumber} 处开始下载!"
            echo -e "[\033[33m$(date +"%Y-%m-%d %T") Warn\033[0m]  ""此字符操作无效,默认从 ${Endnumber} 处结束下载!"
        ;;
        *)
            echo -e "[\033[33m$(date +"%Y-%m-%d %T") Warn\033[0m]  ""参数输入有误,默认从 ${Startnumber} 处开始下载!"
            echo -e "[\033[33m$(date +"%Y-%m-%d %T") Warn\033[0m]  ""参数输入有误,默认从 ${Endnumber} 处结束下载!"
        ;;
    esac
done
Main

