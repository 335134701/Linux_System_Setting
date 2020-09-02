#! /bin/bash
#判断命令是否执行成功
function Judge_Order(){
	local status=${?}
	echo
	echo
	#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
	if [ ${status} -eq 0 ];then
		echo "${1}"
	else 
		echo "${2}"
		if [ "${3}" -eq 0 ];then
			exit 127
		fi
	fi
	echo
	echo
}
function Judge_Txt()
{
	#查找${1}开头的字符串
	result=`sudo sed -n -e "/^${1}/=" ${fileName}`
	if [ -z "${result}" ];then
		sudo sed -i "\$a\\${1}"  ${fileName}
	else
		sudo sed -i "${result}c\\${1}"  ${fileName}
	fi
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

