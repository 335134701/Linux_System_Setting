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

INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
DEBUGTime="[\033[36m$(date +"%Y-%m-%d %T") Debug\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "


#判断命令是否执行成功
#${1}:执行的命令语句
function Judge_Order(){
	local status=${?}
	if [ ${#} -eq 2 ];then
		#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
		if [ ${status} -eq 0 ];then
			echo -e ${INFOTime}"\033[33m\"${1}\" \033[0m""\033[34mexecute success!\033[0m"
		else 
			echo -e  ${INFOTime}"\033[33m\"${1}\" \033[0m""\033[34mexecute fail!\033[0m"
			if [ "${2}" -eq 0 ];then
				exit 127
			fi
		fi	
	else
		echo -e ${ERRORTime}"\033[31mIncorrect function parameter input, the \"Judge_Order()\" is about to terminate execution!\033[0m"
		return 80
	fi
}
#判断文件是否存在
function Judge_FileIsExist()
{
	if [ ! -f ${filename} ];then
		echo -e ${ERRORTime}"\033[31mThe file \"${filename}\" does not exist, the program is about to terminate execution!\033[0m"	
		exit 90
	fi
}
#配置文件修改
#当result值为不空时，${3}=1表示在${1}上一行插入${2}
#当result值为不空时，${3}=2表示在${1}下一行插入${2}
function Judge_Txt()
{
	echo
	local result=''
	if [ ${#} -ge 1 ] && [ ${#} -le 3 ];then
		if [ $(cat ${filename} 2>&1 | wc -l) -eq 0 ] || [ ! -f ${filename} ] ;then
			echo ${1} > ${filename}
		else
			Judge_FileIsExist
			result=`sudo grep -E -n ^"${1}" ${filename} | cut -d ":" -f 1` 
			if [ -z "${result}" ];then
				result=`sudo grep -E -n "${1}" ${filename} | cut -d ":" -f 1` 
			fi
			if [ -z "${result}" ] && [ ${#} -eq 1 ];then
				sudo sed -i \$a"${1}"  ${filename}
				Judge_Order "sudo sed -i \$a\"${1}\"  ${filename}" 0
			elif [ -n "${result}" ] && [[ ${3} -eq 1 ]];then
				resultt=`sudo grep -E -n ^"${2}" ${filename}`
				if [ -z "${resultt}" ];then 
					sudo sed -i "${result}i${2}"  ${filename}
					Judge_Order "sudo sed -i \"${result}a${2}\"  ${filename}" 0
				fi
			elif [ -n "${result}" ] && [[ ${3} -eq 2 ]];then
				resultt=`sudo grep -E -n ^"${2}" ${filename}`
				if [ -z "${resultt}" ];then 
					sudo sed -i "${result}a${2}"  ${filename}
					Judge_Order "sudo sed -i \"${result}a${2}\" ${filename}" 0
				fi
			elif [ -n "${result}" ] && [ ${#} -eq 2 ];then
				sudo sed -i 's/'"${1}/${2}"'/g'  ${filename}
				Judge_Order "sudo sed -i 's/'\"${1}/${2}\"'/g'  ${filename}" 0
			fi
		fi
	else
		echo -e ${ERRORTime}"\033[31mIncorrect function parameter input, the program is about to terminate execution!\033[0m"
		return 80
	fi
	echo 
}

function Welcome()
{
	echo
	echo
	echo
	echo -e "\033[34m*****************************************************\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	((num=28-${#0}))
	if [ ${num} -gt 0 ];then
		echo -e "\033[34m**          Welcome to \033[0m\033[33m${0}\c\033[0m"
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

#选择在线安装或者离线安装
function Frp_Install()
{
    echo
	filename=`ls $(pwd)/frp_*.tar.gz`
	echo "-----------------"${filename}
	cp -r ${filename} ${ClientDir}/frp.tar.gz
	Judge_Order "sudo cp -r ${filename} ${ClientDir}/frp.tar.gz" 0
	filename=${ClientDir}/frp.tar.gz
	tar -zxvf ${filename} -C ${ClientDir}/
	Judge_Order "tar -zxvf ${filename} ${ClientDir}/" 0
	cp -r ${ClientDir}/frp_*/* ${ClientDir}
	Judge_Order "cp -r ${ClientDir}/frp_*/* ${ClientDir}" 0
	rm -rf ${ClientDir}/frp_*
	chmod 777  ${ClientDir}/*

	filename=${ClientDir}/frpc.ini
	sudo rm -rf ${ClientDir}/frps*
	Judge_Txt "\[ssh\]" "[ssh001]"
	Judge_Txt "server_addr.*" "server_addr = ${server_addr}"
	Judge_Txt "server_port.*" "server_port = ${bind_port}"

	Judge_Txt "local_ip.*" "local_ip = ${local_ip}"
	Judge_Txt "remote_port.*" "remote_port = ${ssh_remote_port}"
    	echo 
}

function Create_frpSH()
{
	echo 
	fileN=${ClientDir}/frp.sh
	touch ${fileN}
	chmod 777 ${fileN}
	echo '#! /bin/bash' >> ${fileN}
	echo "if [ -f ${HOME}/Software/Frp/frpc ] && [ -f ${HOME}/Software/Frp/frpc.ini ];then" >> ${fileN}
	echo '	local_ip=$(ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6|awk '"'{print \$2}'"')' >> ${fileN}
	echo '	local_ip=$( echo ${local_ip} | cut -d ":" -f2)' >> ${fileN}
	echo "	sudo sed -i 's/'\"local_ip.*/local_ip = \${local_ip}\"'/g'  ${HOME}/Software/Frp/frpc.ini" >> ${fileN}
	echo '	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Frp client is runing!" ' >> ${fileN}
	echo "	${ClientDir}/frpc -c ${ClientDir}/frpc.ini" >> ${fileN}
	echo 'else' >> ${fileN}
	echo '	echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""The file frpc&frpc.ini is not existence!" ' >> ${fileN}
	echo 'fi' >> ${fileN}
    	echo 
}

function Main()
{
	#*********************************************************
	#根据需要修改如下参数
	#客户端端目录
	ClientDir=${HOME}/Software/Frp
	#服务器IP地址或域名，根据实际修改
	server_addr=www.zchbwl.cn
	#frp通信端口号，根据实际需要修改
	bind_port=6000
	#本地IP,无需进行操作
	#local_ip=$(LC_ALL=C ifconfig|grep "inet addr:"|grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}')
	#下列方法会获取ech0 和wlan0两种IP地址
	local_ip=$(ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6|awk '{print $2}')
	local_ip=$( echo ${local_ip} | cut -d ":" -f2)
	#ssh对应的端口号，根据实际修改
	ssh_remote_port=6868
	#*********************************************************
    	#第一步:执行欢迎方法
    	Welcome
    	#第二步:安装Client端
    	echo
    	#echo -e ${WARNTime}"If the input options below are incorrect, they will be executed according to the default selection!"
    	echo
	sudo rm -rf ${ClientDir}
	mkdir -p ${ClientDir}
    	#第三步:离线安装
	Frp_Install
    	#第六步:创建脚本文件
	Create_frpSH
    	#第七步:执行脚本
	echo -e ${INFOTime}"启动frp方法:执行 ${ClientDir}/frp.sh  !"
}
Main
