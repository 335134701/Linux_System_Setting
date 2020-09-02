#! /bin/bash
#**********************************************************
# 错误代码说明：
	# 0:表示正确
	# 1:表示错误
	# 2:表示软件已经安装，安装方式dpkg 
	# 3:表示软件未安装，将要安装，安装方式dpkg
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
	Judge_Order "Judge_Txt() : ${1}" 1
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
    local isChoose=0
    echo -e ${INFOTime}"The Method \" Frp_Install() \" starts execution!"
    if [ ${isOnline} = "O" ];then
    	sudo wget -c -O ${HOME}/frp.tar.gz ${URL}
		Judge_Order "sudo wget -c -O ${HOME}/frp.tar.gz ${URL}" 0
    else
        while [ ${isChoose} -eq 0 ];
        do
            read -t 30 -p "Please enter the directory where the frp compressed package is located(eg:/demo):" filename
            if [ -f ${filename}/frp*.tar.gz ] && [ -n ${filename} ] && [ ${filename} != " " ];then
               isChoose=1
		filename=${filename}/frp*.tar.gz
               echo -e ${INFOTime}"The file \" ${filename} \" is existence!"
               break
            fi
            echo -e ${WARNTime}"The file \" ${filename} \" is not existence!"
	　　　　filename=''
        done
    fi
	if [ ${isClient} = "S" ];then
		sudo cp -r ${filename} ${ServerDir}/frp.tar.gz
		Judge_Order "sudo cp -r ${filename} ${ServerDir}/frp.tar.gz" 0
		filename=${ServerDir}/frp.tar.gz
		sudo tar -zxvf ${filename} -C ${ServerDir}/
		Judge_Order "tar -zxvf ${filename} ${ServerDir}/" 0
		sudo cp -r ${ServerDir}/frp_*/* ${ServerDir}
		Judge_Order "sudo cp -r ${ServerDir}/frp_*/* ${ServerDir}" 0
		sudo rm -rf ${ServerDir}/frp_*
		sudo chmod 777  ${ServerDir}/*
		filename=${ServerDir}/frps.ini
        sudo rm -rf ${ServerDir}/frpc*
		Judge_Txt "bind_port.*" "bind_port = ${bind_port}"
    else
		sudo cp -r ${filename} ${ClientDir}/frp.tar.gz
		Judge_Order "sudo cp -r ${filename} ${ClientDir}/frp.tar.gz" 0
		filename=${ClientDir}/frp.tar.gz
		sudo tar -zxvf ${filename} -C ${ClientDir}/
		Judge_Order "tar -zxvf ${filename} ${ClientDir}/" 0
		sudo cp -r ${ClientDir}/frp_*/* ${ClientDir}
		Judge_Order "sudo cp -r ${ClientDir}/frp_*/* ${ClientDir}" 0
		sudo rm -rf ${ClientDir}/frp_*
		sudo chmod 777  ${ClientDir}/*

		filename=${ClientDir}/frpc.ini
        sudo rm -rf ${ClientDir}/frps*
		Judge_Txt "server_addr.*" "server_addr = ${server_addr}"
		Judge_Txt "server_port.*" "server_port = ${bind_port}"
		Judge_Txt "local_ip.*" "local_ip = ${local_ip}"
		Judge_Txt "local_port.*" "local_port = ${ssh_local_port}"
		Judge_Txt "remote_port.*" "remote_port = ${ssh_remote_port}"

		echo >> ${filename}
		echo "[vnc]" >> ${filename}
		echo "type = tcp" >> ${filename}
		echo "local_ip = ${local_ip}" >> ${filename}
		echo "local_port = ${vnc_local_port}" >> ${filename}
		echo "remote_port = ${vnc_remote_port}" >> ${filename}
    fi
    echo -e ${INFOTime}"The Method \" Frp_Install() \" ends!"
    echo 
}

function Create_frpSH()
{
	echo 
	echo -e ${INFOTime}"The Method \" Create_frpSH() \" starts execution!"
	sudo touch ${fileN}
	sudo chmod 777 ${fileN}
	if [ ${isClient} = "S" ];then
		echo '#! /bin/bash' >> ${fileN}
		echo "if [ -f ${HOME}/Frp/frps ] && [ -f ${HOME}/Frp/frps.ini ];then" >> ${fileN}
		echo "	nohup ${HOME}/Frp/frps -c ${HOME}/Frp/frps.ini >/dev/null 2>&1 &" >> ${fileN}
		echo '	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Frp server is runing!" ' >> ${fileN}
		echo 'else' >> ${fileN}
		echo '	echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""The file frps&frps.ini is not existence!" ' >> ${fileN}
		echo 'fi' >> ${fileN}
	else
		echo '#! /bin/bash' >> ${fileN}
		echo 'sleep 10s' >> ${fileN}
		echo "if [ -f ${HOME}/Software/Frp/frpc ] && [ -f ${HOME}/Software/Frp/frpc.ini ];then" >> ${fileN}
		echo '	local_ip=$(ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6|awk '"'{print \$2}'"')' >> ${fileN}
		echo '	local_ip=$( echo ${local_ip} | cut -d ":" -f2)' >> ${fileN}
		echo "	sudo sed -i 's/'\"local_ip.*/local_ip = \${local_ip}\"'/g'  ${HOME}/Software/Frp/frpc.ini" >> ${fileN}
		echo "	nohup ${HOME}/Software/Frp/frpc -c ${HOME}/Software/Frp/frpc.ini >/dev/null 2>&1 &" >> ${fileN}
		echo '	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Frp client is runing!" ' >> ${fileN}
		echo 'else' >> ${fileN}
		echo '	echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""The file frpc&frpc.ini is not existence!" ' >> ${fileN}
		echo 'fi' >> ${fileN}
	fi
	echo -e ${INFOTime}"The Method \" Create_frpSH() \" ends!"
    echo 
}

function Main()
{
	#*********************************************************
	#根据需要修改如下参数
	#Server端目录
	ServerDir=${HOME}/Frp
	#客户端端目录
	ClientDir=${HOME}/Software/Frp
	#URL:frp压缩包下载路径，根据PC或者服务器架构修改相应的链接(在线安装模式需要修改)
	URL=https://github.com/fatedier/frp/releases/download/v0.32.1/frp_0.32.1_linux_amd64.tar.gz
	#服务器IP地址或域名，根据实际修改
	server_addr=www.stc15.com
	#frp通信端口号，根据实际需要修改
	bind_port=6000
	#本地IP,无需进行操作
	#local_ip=$(LC_ALL=C ifconfig|grep "inet addr:"|grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}')
	#下列方法会获取ech0 和wlan0两种IP地址
	local_ip=$(ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6|awk '{print $2}')
	local_ip=$( echo ${local_ip} | cut -d " " -f1)
	#ssh对应的端口号，根据实际修改
	ssh_local_port=6555
	ssh_remote_port=6555
	#VNC对应的端口号，根据实际修改
	vnc_local_port=5900
	vnc_remote_port=5999
	#*********************************************************
    #第一步:执行欢迎方法
    Welcome
    #第二步:选择安装Server端还是Client端
    echo
	echo -e ${WARNTime}"Tips:下面程序运行过程中，如果输入错误，将按照默认选项执行!"
	sleep 3s
    #echo -e ${WARNTime}"If the input options below are incorrect, they will be executed according to the default selection!"
    echo
	echo -e ${WARNTime}"Tips:请选择安装服务端或者客户端，输入:S/s或者C/c，默认执行C/c(客户端)!"
    read -t 8 -n 1 -p "Please choose to install the Server or Client(S/C Default:Clent):" isClient
    echo
    if [ ${isClient} = "S" -o ${isClient} = "s" ];then
        isClient="S"
		sudo rm -rf ${ServerDir}
		sudo mkdir -p ${ServerDir}
		fileN=${ServerDir}/frp.sh
        echo -e ${INFOTime}"The Server will be installed according to your choice!"
    else
        isClient="C"
		sudo rm -rf ${ClientDir}
		sudo mkdir -p ${ClientDir}
		fileN=${ClientDir}/frp.sh
        echo -e ${INFOTime}"The Client will be installed according to your choice!"
    fi
    #第三步:选择在线安装还是离线安装
	echo -e ${WARNTime}"Tips:请选择在线安装还是离线安装，在线安装比较慢，输入:O/o或者F/f，默认执行O/o(在线安装)!"
    read -t 8 -n 1 -p "Please choose to install Online or Offline(O/F Default:Online):" isOnline
    echo
    if [ ${isOnline} = "F" -o ${isOnline} = "f" ];then
        isOnline="F"
        echo -e ${INFOTime}"According to your choice, Frp will be installed offline!"
    else
        isOnline="O"
        echo -e ${INFOTime}"According to your choice, Frp will be installed online!"
    fi
    #第四步:根据选择进行安装(注意树莓派的端口不同，下载链接也不同，需要修改)
	Frp_Install
	#第五步:如果是服务端,修改防火墙端口
	if [ ${isClient} = "S" ];then
		filename=/etc/sysconfig/iptables
		Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${bind_port} -j ACCEPT" 1
		Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${ssh_remote_port} -j ACCEPT" 1
		Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${vnc_remote_port} -j ACCEPT" 1
		sudo service iptables restart
		Judge_Order "sudo service iptables restart" 0
	fi
    #第六步:创建脚本文件
	Create_frpSH
    #第七步:将脚本文件加入程序启动项中
	echo -e ${WARNTime}"Tips:请选择在线是否加入自启动运行，输入:Y/y或者N/n，默认执行Y/y(自启动)!"
    read -t 8 -n 1 -p "Please choose to install Online or Offline(Y/N Default:Self-start):" isOn
    echo
    if [ ${isOn} = "N" -o ${isOn} = "n" ];then
        isOn="N"
        echo -e ${INFOTime}"According to your choice, Frp will not join the self-start!"
		#第八步:提示如何启动脚本
		if [ ${isClient} = "S" ];then
			echo -e ${INFOTime}"启动frp方法:执行${ServerDir}/frp.sh!"
		else
			echo -e ${INFOTime}"启动frp方法:执行${ClientDir}/frp.sh!"
		fi
    else
        isOn="Y"
        echo -e ${INFOTime}"According to your choice, Frp will join the self-start!"
		if [ ${isClient} = "S" ];then
			filename=/etc/rc.d/rc.local
			if [ -f ${filename} ];then
				Judge_Txt "touch*" "${HOME}/Frp/frp.sh start" 2
			else
				echo -e ${ERRORTime}"The file \" ${filename} \" is not existence!"
				exit 127
			fi
			echo -e ${INFOTime}"frp服务程序安装成功，重启后将生效!"
		else
			filename=/etc/rc.local
			if [ -f ${filename} ];then
				Judge_Txt "exit 0" "su pi ${HOME}/Software/Frp/frp.sh" 1
			else
				echo -e ${ERRORTime}"The file \" ${filename} \" is not existence!"
				exit 127
			fi
			echo -e ${INFOTime}"frp服务程序安装成功，重启后将生效!"
		fi
    fi
}
Main
