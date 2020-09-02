#! /bin/bash
INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "
#判断命令是否执行成功
#${1}:执行的命令语句
function Judge_Order(){
	echo
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
	echo
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
function Judge_Txt()
{
	echo
	local result=''
	if [ ${#} -eq 1 ] || [ ${#} -eq 2 ];then
		Judge_FileIsExist
		if [ $(cat ${filename} 2>&1 | wc -l) -eq 0 ] ;then
			echo ${1} > ${filename}
		else
			result=`grep -E -n ^"${1}" ${filename}` 
			if [ -z "${result}" ];then
				result=`grep -E -n "${1}" ${filename}` 
			fi
			if [ -z "${result}" ];then
				sudo sed -i \$a"${1}"  ${filename}
				Judge_Order "sudo sed -i \$a\"${1}\"  ${filename}" 0
			elif [ -n "${result}" ] && [ ${#} -eq 2 ];then
				
				sudo sed -i 's/'"${1}/${2}"'/g'  ${filename}
				Judge_Order "sudo sed -i 's/'\"${1}/${2}\"'/g'  ${filename}" 0
			fi
		fi
	else
		echo -e ${ERRORTime}"\033[31mIncorrect function parameter input, the program is about to terminate execution!\033[0m"
		exit 80
	fi
	Judge_Order "Judge_Txt() : ${1}" 1
	echo 
}
function Static_IP()
{
	#设置静态IP
	fileName='/etc/network/interfaces'
	if [ -f "${fileName}" ];then
		i=5
		ifconfig
		read -p "Please input the Network card name:" networkCard
		cat /sys/class/net/${networkCard}/address
		while [[ "${?}" -ne 0 ]]
		do
			let "i-=1"
			if [ ${i} -eq 0 ];then
				echo "Your input is fail , the program is over"
				#exit 127
				break 
			fi
			read -p "Your input is error,Please input again:" networkCard
			cat /sys/class/net/${networkCard}/address
		done
		networkCard="enp1s0"
		Judge_Txt 'auto lo'
		Judge_Txt 'iface lo inet loopback'
		Judge_Txt "auto\ ${networkCard}"
		Judge_Txt "iface\ ${networkCard}\ inet\ static"
		read -p "if not use the default IP(Yes/No):" answer
		if [ "${answer}" = "Yes" ] || [ "${answer}" = "yes" ] || [ "${answer}" = "YES" ];then
			Compare='^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$'
			read -p "Please input the new address:" address
			if [[ "${address}" =~ ${Compare} ]];then   
				Judge_Txt "address\ ${address}"
			else
			 	echo "Your input ${address} is error,the program is over"
				exit 127
			fi
			read -p "Please input the new netmask:" netmask
			if [[ "${netmask}" =~ ${Compare} ]];then  
				Judge_Txt "netmask\ ${netmask}"
			else
			 	echo "Your input ${netmask} is error,the program is over"
				exit 127
			fi
			read -p "Please input the new gateway:" gateway
			if [[ "${gateway}" =~ ${Compare} ]];then  
				Judge_Txt "gateway\ ${gateway}"
			else
			 	echo "Your input ${gateway} is error,the program is over"
				exit 127
			fi
		else
			address="192.168.1.107"
			netmask="255.255.255.0"
			gateway="192.168.1.1"
			echo "Your select is the default configuration"
			Judge_Txt "address\ ${address}"
			Judge_Txt "netmask\ ${netmask}"
			Judge_Txt "gateway\ ${gateway}"
		fi
		sudo service networking restart
	else  
		echo "The file ${fileName} is not existence!"
	fi
	ping -c 4  ${address}
	Judge_Order "File configuration succeess" "File configuration fail" 0
}

Static_IP

