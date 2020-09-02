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

#**********************************************************
#初始化界面设置相关操作:
	# 1.开启SSH:系统烧录完成后,在SD卡根目录新建SSH文件
	# 2.获取树莓派IP,SSH连接树莓派:User:pi;Passwd:raspberry   
	# 3.输入命令vncserver,可临时远程界面VNC Viewer连接
	# 4.打开vnc viewer,配置:VNC Server: IP:5900/5901; Name:pi
	# 5.连接成功,打开命令行,输入:sudo raspi-config
	# 6.开机自启动SSH:Interfacing Options->SSH->是->Enter键
	# 7.开机自启动VNC:Interfacing Options->VNC->是->Enter键     
	# 8.设置中文环境:Change Locale->选择:zh_CN.GB2312;zh_CN.GB18030;zh_GBK;zh_CN.UTF-8->OK
	#   注意:空格键可选择多选或取消多选
	# 9.若SD卡空间大于树莓派显示空间,可扩展空间:Advanced Options->Al Expand Filesystem->确定
	# 10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定
#**********************************************************

INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
DEBUGTime="[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "

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
#初始化界面设置相关操作显示
function Description_Init_Desktop()
{
	echo
	echo
	echo
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**  初始化界面设置相关操作:                                                                        **\033[0m"
	echo -e "\033[34m**      1.开启SSH:系统烧录完成后,在SD卡根目录新建SSH文件                                           **\033[0m"
	echo -e "\033[34m**      2.获取树莓派IP,SSH连接树莓派:User:pi;Passwd:raspberry                                      **\033[0m"
	echo -e "\033[34m**      3.输入命令vncserver,可临时远程界面VNC Viewer连接                                           **\033[0m"
	echo -e "\033[34m**      4.打开vnc viewer,配置:VNC Server: IP:5900/5901; Name:pi                                    **\033[0m"
	echo -e "\033[34m**      5.连接成功,打开命令行,输入:sudo raspi-config                                               **\033[0m"
	echo -e "\033[34m**      6.开机自启动SSH:Interfacing Options->SSH->是->Enter键     			           **\033[0m"
	echo -e "\033[34m**      7.开机自启动VNC:Interfacing Options->VNC->是->Enter键                                      **\033[0m"
	echo -e "\033[34m**      8.设置中文环境:Change Locale->选择:zh_CN.GB2312;zh_CN.GB18030;zh_GBK;zh_CN.UTF-8->OK       **\033[0m"
	echo -e "\033[34m**        注意:空格键可选择多选或取消多选                                                          **\033[0m"
	echo -e "\033[34m**      9.若SD卡空间大于树莓派显示空间,可扩展空间:Advanced Options->Al Expand Filesystem->确定     **\033[0m"
	echo -e "\033[34m**      10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定                     **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo
	echo
	echo
}
#用于说明某些信息
#${1}:输出信息
function Description_Information()
{
	echo
	echo
	echo
		echo -e "\033[34m*****************************************************\033[0m"
		echo -e "\033[34m**                                                 **\033[0m"
		echo -e "\033[34m**                                                 **\033[0m"
		echo -e "\033[34m**                                                 **\033[0m"
	while (( ${#} > 0 ))
	do
		((num=45-${#1}))
		if [ ${num} -gt 0 ];then
			echo -e "\033[34m**    \033[0m\033[33m${1}\c\033[0m"
			for((i=0;i<${num};i++))
			do
				echo -e " \c"
			done
			echo -e "\033[34m**\033[0m\c"
			echo
		else
			echo -e "\033[34m**    \033[0m\033[33m${1}\033[0m"
			break 2
		fi
		shift
	done 
		echo -e "\033[34m**                                                 **\033[0m"
		echo -e "\033[34m**                                                 **\033[0m"
		echo -e "\033[34m**                                                 **\033[0m"
		echo -e "\033[34m*****************************************************\033[0m"
	echo
	echo
	echo
}
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

#更新软件环境
function Update_ALL()
{
	echo
	sudo apt-get update -y
	Judge_Order 'sudo apt-get update -y' 1
	sudo apt-get upgrade -y
	Judge_Order 'sudo apt-get upgrade -y' 1
	echo -e ${INFOTime}"\033[34mThe method \"CheckOrInstall_Software()\" run success!\033[0m"
	echo
}
#判断方法是否继续执行
#${1}:传入用户选择；
#${2}:传入需要执行的方法
function Judge_MethodIsExecute()
{
	echo
	local mtehodStatus=126	
	if [ ${#} -eq 2 ];then
		if [[ ${1} = 'Y' || ${1} = 'y' ]];then
			mtehodStatus=0
			echo -e ${INFOTime}"\033[34mYour choice is \"${1}\", the \"${2}()\" method will start executing!\033[0m"
		elif [[ ${1} = 'N' || ${1} = 'n' ]];then
			mtehodStatus=1
			echo -e ${INFOTime}"\033[31mYour choice is \"${1}\", the \"${2}()\" method will not start executing!\033[0m"
		elif [ -z ${1} ];then
			mtehodStatus=125
			echo -e ${INFOTime}"\033[31mYou do not select within 5 seconds, the \"${2}()\" method will execute by default!\033[0m"
		else
			mtehodStatus=124
			echo -e ${INFOTime}"\033[31mYour input is incorrect and the \"${2}()\" method will execute by default!\033[0m"
		fi
	else
		echo -e ${ERRORTime}"\033[31mIncorrect function parameter input, the \"Judge_MethodIsExecute()\" is about to terminate execution!\033[0m"
		return 80
	fi
	echo
	return ${mtehodStatus}
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

#处理重复性软件流程
#${1}:执行方法名称
function Software_Install()
{
	echo
	local isChoose='Y'
	local isChooseMode=126
	if [ ${#} -eq 1 ];then
		if [ "$(type -t ${1})" = "function" ] ; then
    			read -t 5 -n 1 -p "Please choose whether to execute the ${1}() method(Y/N):" isChoose
				echo
				#Determine whether to execute method
				Judge_MethodIsExecute ${isChoose} ${1}
				#Get Judge_MethodIsExecute() function return value
				isChooseMode=${?}
				#Determine whether to execute  method
				if [ ${isChooseMode} -ne 1 ] && [ ${isChooseMode} -ne 126 ];then
					${1}
				fi
		else
			echo -e ${ERRORTime}"\033[31mThe method \"Software_Install()\" dose not exist!\033[0m"
			return 82
		fi
		
	else
		echo -e ${ERRORTime}"\033[31mThe method \"Software_Install()\" unction parameter input is incorrect, please re-enter!\033[0m"
		return 80	
	fi
	echo -e ${INFOTime}"\033[34mThe method \"Software_Install()\" run success!\033[0m"
	echo
}
#执行其他脚本文件
#${1}:脚本文件名称及目录
function Run_SHFile()
{
	if [ ! -f ${1} ];then
		sudo chmod 755 ${1}
		./${1}
		Judge_Order "${1}" 1
	else
		echo -e ${ERRORTime}"\033[31mThe file ${1} is not existence!\033[0m"
	fi
}
#校验库文件Raspberry_Library.sh是否存在
:<<!
function Check_Library()
{
	echo
	if [ ! -f $(pwd)/Raspberry_Library.sh ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m当前目录:$(pwd),库文件(Raspberry_Library.sh)不存在,程序无法继续执行!\033[0m"
		exit 90
	else
		echo -e ${INFOTime}"\033[34m当前目录:$(pwd),库文件(Raspberry_Library.sh)存在,程序将开始执行!\033[0m"
		. Raspberry_Library.sh
	fi
	echo
}
!
#设置静态IP
function Set_Static_IP()
{
	echo
    filename=/etc/dhcpcd.conf
	read -t 10 -p "请选择设置无线静态IP或有线静态IP(E:有线;W:无线;默认无线): " isChoose
	if [ ${isChoose} = "E" -o ${isChoose} = "e" ];then
		echo -e ${INFOTime}"\033[34m你的输入是:${isChoose},根据你的选择,将设置有线静态IP!\033[0m"
        Judge_Txt "#interface eth0" "interface eth0"
	elif [ ${isChoose} = "W" -o ${isChoose} = "w" ];then
		echo -e ${INFOTime}"\033[34m34m你的输入是:${isChoose},根据你的选择,将设置无线静态IP!\033[0m"
        Judge_Txt "interface wlan0"
	else
		echo -e ${WARNTime}"\033[33m34m你的输入是:${isChoose},输入错误,系统将默认设置有线静态IP!\033[0m"
        Judge_Txt "#interface eth0" "interface eth0"
	fi
    Judge_Txt "static ip_address=192.168.0.150\/24"
	Judge_Txt "static routers=192.168.0.1"
	Judge_Txt "static domain_name_servers=114.114.114.114 8.8.8.8"
	echo -e ${INFOTime}"\033[34mThe method \"Set_Static_IP()\" run success!\033[0m"
	echo
}

#更改YUM源
function Replace_YUM_Source()
{
	echo
	#备份源文件
	filename=/etc/apt/sources.list.d/raspi.list
	#if [ ! -f ${filename}.*.bak ];then
	#	sudo cp ${filename} ${filename}_$(date "+%Y-%m-%d").bk
	#fi
	#修改源码
	Judge_Txt "^deb http:\/\/archive.raspberrypi.org\/debian\/ buster" "#deb http:\/\/raspbian.raspberrypi.org\/raspbian\/ buster"
	Judge_Txt "^deb-src http:\/\/archive.raspberrypi.org\/debian\/ buster" "#deb-src http:\/\/archive.raspberrypi.org\/debian\/ buster"
	Judge_Txt 'deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui'
	Judge_Txt 'deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui'
	filename=/etc/apt/sources.list
	#备份源码
	#if [ ! -f ${filename}.*.bak ];then
	#	sudo cp ${filename} ${filename}_$(date "+%Y-%m-%d").bk	
	#fi
	#修改源码
	Judge_Txt "^deb http:\/\/raspbian.raspberrypi.org\/raspbian\/ buster" "#deb http:\/\/raspbian.raspberrypi.org\/raspbian\/ buster"
	Judge_Txt "^deb-src http:\/\/raspbian.raspberrypi.org\/raspbian\/ buster" "#deb-src http:\/\/raspbian.raspberrypi.org\/raspbian\/ buster"
	Judge_Txt 'deb http://mirror.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main contrib non-free rpi'
	Judge_Txt 'deb-src http://mirror.tuna.tsinghua.edu.cn/raspbian/raspbian/ buster main contrib non-free rpi'
	echo -e ${INFOTime}"\033[34mThe method \"Replace_YUM_Source()\" run success!\033[0m"
	echo
}

function Install_Firewall()
{
	
	echo
	#安装防火墙
	sudo apt-get install ufw -y
	#启用防火墙
	sudo ufw enable
	#关闭外部对本机访问
	sudo ufw default deny
	Judge_Order "sudo ufw default deny" 0
	sudo ufw allow 3306
	Judge_Order "sudo ufw allow 3306" 0
	sudo ufw allow 22
	Judge_Order "sudo ufw allow 22" 0
	sudo ufw allow 5900
	Judge_Order "sudo ufw allow 5900" 0
	#sudo ufw allow 20
	#Judge_Order "sudo ufw allow 20" 0
	#sudo ufw allow 21
	#Judge_Order "sudo ufw allow 21" 0
	#以下是防火墙相关操作说明:
			#sudo ufw allow 80 允许外部访问80端口
			#sudo ufw delete allow 80 禁止外部访问80 端口
			#sudo ufw allow from 192.168.1.1 允许此IP访问所有的本机端口
			#sudo ufw deny smtp 禁止外部访问smtp服务
			#sudo ufw delete allow smtp 删除上面建立的某条规则
			#ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port要拒绝所有的流量从TCP的10.0.0.0/8 到端口22的地址192.168.0.1
			#可以允许所有RFC1918网络（局域网/无线局域网的）访问这个主机（/8,/16,/12是一种网络分级）：
			#sudo ufw allow from 10.0.0.0/8
			#sudo ufw allow from 172.16.0.0/12
			#sudo ufw allow from 192.168.0.0/16
			#配置允许的端口范围 
			#sudo ufw allow 6000:6007/tcp 
			#sudo ufw allow 6000:6007/udp
	echo -e ${INFOTime}"\033[34mThe method \"Install_Firewall()\" run success!\033[0m"
	echo

}
#修改 SSH Port 端口号
function Change_SSH_Port()
{
	echo
	local Status=126,sshport=22
	#获取新输入的端口号
	while [[ ${Status} -ne 0 ]]
	do
		read -t 30 -p "Please input a new SSH port(1000~65535):" sshport
		echo
		if [ -z "${sshport}" ];then
			sshport=22
			Status=0
			echo -e ${INFOTime}"\033[34mYou did not enter a new SSH port within 30 seconds\033[0m"
			echo -e ${INFOTime}"\033[34mThe system will use the default SSH port :\033[0m\033[31m${sshport}\033[0m"
		elif [[ ${sshport} =~ ^[0-9]*[1-9][0-9]*$ ]] && [[ ${sshport} -ge 1000 ]] && [[ ${sshport} -lt 65535 ]];then
			Status=0
			echo -e ${INFOTime}"\033[34mThe SSH port you entered is:\033[0m\033[33m${sshport}\033[0m"
		elif [ ${sshport} -eq 22 ];then
			sshport=22
			Status=0
			echo -e ${INFOTime}"\033[34mThe SSH port you entered is:\033[0m\033[33m${sshport}\033[0m"	
		else
			Status=126
			echo -e ${ERRORTime}"\033[31mThe SSH port you entered is not in (1000~65535), please try again!\033[0m"
		fi
	done
	filename=/etc/ssh/sshd_config
	#获取原来的端口号
	oldPort=`sudo grep -E -n ^Port ${filename} | cut -d " " -f 2`
	#如果oldPort未获取到值，说明sshd_config文件中Port为初始状态
	if [ -z "${oldPort}" ];then
		oldPort=22
		Judge_Txt "#Port.*" "Port\ ${sshport}"
	else
		Judge_Txt "Port.*" "Port\ ${sshport}"
	fi
	sudo ufw delete allow ${oldPort}
	Judge_Order "sudo ufw delete allow ${oldPort}" 0
	sudo ufw allow ${sshport}
	Judge_Order "sudo ufw allow ${sshport}" 0
	sudo service sshd start
	Judge_Order 'sudo service sshd start' 1
	sudo service sshd restart
	Judge_Order 'sudo service sshd restart' 0	
	Description_Information "The old SSH port number is:${oldPort}" "The new SSH port number is:${sshport}"
	echo -e ${INFOTime}"\033[34mThe method \"Change_SSH_Port()\" run success!\033[0m"
	echo
}
function Install_VSftp()
{
	echo
	local Status=126,VsftpdPort=21
	local newmkdir='/home/pi/www',vsftpname='pi'
	sudo apt-get install vsftpd -y
	Judge_Order "sudo apt-get install vsftpd -y" 0
	sudo service vsftpd start
	Judge_Order "sudo service vsftpd start" 0
	#创建一个新的目录
	while [[ ${Status} -ne 0 ]]
	do
		read -t 30 -p "Please enter the name of the directory to be created(E.g www/test):" newmkdir
		echo
		if [ -z "${newmkdir}" ];then
			newmkdir='/home/pi/www'
			echo -e ${INFOTime}"\033[34mYou did not enterthe name of the directory within 30 seconds\033[0m"
			echo -e ${INFOTime}"\033[34mThe system will use the default directory :\033[0m\033[31m${newmkdir}\033[0m"
		else
			newmkdir=/home/pi/${newmkdir}
			echo -e ${INFOTime}"\033[34mThe name of the directory you entered is:\033[0m\033[33m${newmkdir}\033[0m"	
		fi
		
		if [ ! -d ${newmkdir} ];then
			mkdir -p ${newmkdir}
			Status=${?}
			if [ ${Status} -ne 0 ];then 
				echo -e ${ERRORTime}"\033[31mThe directory \"${newmkdir}\" create failed, please try again!\033[0m"
			fi
		else
			Status=0
			echo -e ${INFOTime}"\033[34mThe \"${newmkdir}\" directory already exists!\033[0m"	
		fi
	done

	filename=/etc/vsftpd.conf
	Judge_Txt "anonymous_enable.*" "anonymous_enable=NO"
	Judge_Txt "#write_enable.*" "write_enable=YES"
	Judge_Txt "local_root=${newmkdir}"
	Judge_Txt "allow_writeable_chroot=YES"
	Judge_Txt "#local_umask" "local_umask"
	Judge_Txt "#xferlog_file" "xferlog_file"
	Judge_Txt "#xferlog_std_format" "xferlog_std_format"
	Judge_Txt "#idle_session_timeout" "idle_session_timeout"
	Judge_Txt "#data_connection_timeout" "data_connection_timeout"
    Judge_Txt "#ascii_upload.*" "ascii_upload_enable=YES"
	Judge_Txt "#ascii_download.*" "ascii_download_enable=YES"
	Judge_Txt "#ftpd_banner" "ftpd_banner"
	Judge_Txt "#chroot_local.*" "chroot_local_user=NO"
	Judge_Txt "#chroot_list_enable" "chroot_list_enable"
	Judge_Txt "#chroot_list_file" "chroot_list_file"
	Judge_Txt "#utf8_filesystem" "utf8_filesystem"
	filename=/etc/vsftpd.chroot_list
	sudo touch ${filename}
	sudo chmod 777 ${filename}
	Judge_Txt "${vsftpname}" 
	sudo service vsftpd restart
	Judge_Order "sudo service vsftpd restart" 0
	sudo ufw allow ${VsftpdPort}
	Judge_Order "sudo ufw allow ${VsftpdPort}" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_VSftp()\" run success!\033[0m"
	echo
}
#安装JDK
function Install_JDK()
{
	echo
	dir=${HOME}/Software/JDK
	sudo rm -rf ${dir}
	mkdir -p ${dir}
	#wget -c -o ${dir}/jdk.tar.gz https://download.oracle.com/otn/java/jdk/8u251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u251-linux-arm32-vfp-hflt.tar.gz?AuthParam=1592732566_7b20b9343becbeee77272f62bd25472d
	#Judge_Order "wget -c -o ${dir}/jdk-8u202-linux-arm32-vfp-hflt.tar.gz https://download.oracle.com/otn/java/jdk/8u251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u251-linux-arm32-vfp-hflt.tar.gz?AuthParam=1592732566_7b20b9343becbeee77272f62bd25472d" 0
	scp -P 5555 zc@www.stc15.com:/demo/jdk.tar.gz ${dir}
	Judge_Order "scp zc@www.stc15.com:/demo/jdk.tar.gz ${dir}" 0
	tar -zxvf  ${dir}/jdk.tar.gz -C ${dir}
	filename=/etc/profile
	Judge_Txt "export JAVA_HOME=\/home\/pi\/Software\/Java\/jdk1.8.0_202"
	Judge_Txt 'export PATH=\${JAVA_HOME}\/bin:\${PATH}'
	Judge_Txt 'export CLASSPATH=.:\${JAVA_HOME}\/lib\/dt.jar:\${JAVA_HOME}\/lib\/tools.jar'
	java -version
	Judge_Order "java -version" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_JDK()\" run success!\033[0m"
	echo 
}
function Install_Frp()
{ 
	Run_SHFile "$(pwd)/Frp_Raspberry.sh" 
}
function Upload_Pi()
{
	local PiDir=${HOME}/Software/Pi
	#第二步创建文件夹
    sudo rm -rf ${PiDir}
    mkdir -p ${PiDir}
    #第三步复制Pi.jar
    echo -e ${INFOTime}"Pi.jar将下载............"
    scp -P 5555 zc@www.stc15.com:/demo/Pi.jar ${PiDir}
    Judge_Order "scp -P 5555 zc@www.stc15.com:/demo/Pi.jar ${PiDir}/Pi.jar" 0
    #第四步:复制frp.sh文件
    filename=${HOME}/Software/Frp/frp.sh
	if [ -f ${filename} ];then
        cp ${filename} ${HOME}
        echo -e ${INFOTime}"${filename}文件复制成功!"
    else
        echo -e ${ERRORTime}"The file \" ${filename} \" is not existence!"
    fi
	#第五步:创建脚本文件
	fileN=${PiDir}/Pi.sh
	filename=${PiDir}/Pi.jar
	sudo touch ${fileN}
	sudo chmod 777 ${fileN}
	echo '#! /bin/bash' >> ${fileN}
	echo "if [ -f ${filename} ];then" >> ${fileN}
	echo "	nohup java -jar ${filename} >/dev/null 2>&1 &" >> ${fileN}
	echo '	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Pi.jar is runing!" ' >> ${fileN}
	echo 'else' >> ${fileN}
	echo '	echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""The file Pi.jar is not existence!" ' >> ${fileN}
	echo 'fi' >> ${fileN}
    #第七步:将脚本文件加入程序启动项中
	echo -e ${WARNTime}"Tips:请选择在线是否加入自启动运行，输入:Y/y或者N/n，默认执行Y/y(自启动)!"
    read -t 8 -n 1 -p "Please choose to install Online or Offline(Y/N Default:Self-start):" isOn
    echo
    if [ ${isOn} = "N" -o ${isOn} = "n" ];then
        echo -e ${INFOTime}"According to your choice, Frp will not join the self-start!"
		echo -e ${INFOTime}"启动Pi.jar方法1:java -jar ${PiDir}/Pi.jar"
		echo -e ${INFOTime}"启动Pi.jar方法2:bash ${fileN}"
    else
        echo -e ${INFOTime}"According to your choice, Frp will join the self-start!"
        filename=/etc/rc.local
        if [ -f ${filename} ];then
            Judge_Txt "exit 0" "su pi ${fileN}" 1
        else
            echo -e ${ERRORTime}"The file \" ${filename} \" is not existence!"
            exit 127
        fi
    fi
	echo -e ${INFOTime}"\033[34mThe method \"Upload_Pi()\" run success!\033[0m"
	echo 
}
function Main()
{
    #第一步:显示欢迎界面
    Welcome
    #第二步:显示初始化界面处理操作
    Description_Init_Desktop 
	#第三步:更换YUM源
	Software_Install "Replace_YUM_Source"
	#第四步:系统软件更新
	Update_ALL
	#第五步:开启vncserver
	vncserver
	#第六步:设置界面相关选项
	sudo raspi-config
	#第六步:设置静态IP
	#Software_Install "Set_Static_IP"
	#第七步:安装字体库
	sudo apt-get install -y  ttf-wqy-zenhei
	Judge_Order "sudo apt-get install -y  ttf-wqy-zenhei" 0
	#第八步:安装中文输入法:
	sudo apt-get install scim-pinyin -y
	Judge_Order "sudo apt-get install scim-pinyin" 0
	#第九步:安装vim编辑器
	sudo apt-get install vim -y
	Judge_Order "sudo apt-get install vim -y" 0
	#第十步:判断界面处理是否执行完成
	read -p "请确认界面设置是否完成(Y/N):" isSet
	if [ ${isSet} = "Y" -o  ${isSet} = "y" ];then
		dir=${HOME}/Software
		#sudo rm -rf ${dir}
		mkdir -p ${dir}
		#第十一步:更改Pi用户密码
		echo -e ${INFOTime}"\033[34m请输入新的Pi账户密码!\033[0m"
		sudo passwd pi
		#第十二步:打开防火墙并开放固定端口
		Software_Install "Install_Firewall"
		#第十三步:修改SSH默认端口号
		#Software_Install "Change_SSH_Port"
		#第十四步:安装vsftpd并开放相应端口,默认端口21，默认目录在pi用户目录下
		Software_Install "Install_VSftp"
		#第十五步:安装JDK
		Software_Install "Install_JDK"
		#第十六步:安装GCC G++
		sudo apt-get install gcc g++ -y
		Judge_Order "sudo apt-get install gcc g++ -y" 0
		#第十七步:安装openssh-server
		sudo apt-get install openssh-server -y
		Judge_Order "sudo apt-get install openssh-server -y" 0
		#第十八步:安装Frp客户端
		Software_Install "Install_Frp"
		#第十九步:上传Pi.jar包,并测试是否可用
		Software_Install "Upload_Pi"
	else
		echo -e ${WARNTime}"界面设置未完成,程序即将退出!"
		exit 127
	fi
}
Main