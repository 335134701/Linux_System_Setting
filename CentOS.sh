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
DEBUGTime="[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "
NewUser=${USER}


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
	sudo yum update -y
	Judge_Order 'sudo yum update -y' 1
	sudo yum upgrade -y
	Judge_Order 'sudo yum upgrade -y' 1
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
#判断软件是否安装，如果未安装则安装
#${1}:执行方式选项
#${2}:软件名称
function CheckOrInstall_Software()
{
	echo
	if [ ${#} -eq 2 ];then
		case "${1}" in
			#groupinstall 安装某个软件的多个组件及其依赖
			yumgroup)
					sudo yum groupinstall "${2}" -y
					Judge_Order "sudo yum groupinstall \"${2}\" -y" 0
			;;
			#install 安装单个软件
			yum)
					sudo yum install ${2} -y
					Judge_Order "sudo yum install \"${2}\" -y" 0
			;;
			dpkg)
				sudo dpkg -l ${2}
				local Software_version=${?}
				if [ ${Software_version} -eq 0 ];then
					echo -e  ${INFOTime}"\033[33m\"${1}\" ""aleredy install!\033[0m"
					return 0
				else
					echo -e ${WARNTime}"\033[36m\"${1}\" ""will be installed!\033[0m"
					return 60
				fi
			;;
			make)
			;;
			*)
				echo -e ${ERRORTime}"\033[31mUnknown arguement!\033[0m"
				return 81
			;;
		esac
	else
		echo -e ${ERRORTime}"\033[31mIncorrect function parameter input, the \"CheckOrInstall_Software()\" is about to terminate execution!\033[0m"
		return 80
	fi	  
	echo -e ${INFOTime}"\033[34mThe method \"CheckOrInstall_Software()\" run success!\033[0m"
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

:<<!
#校验库文件CentOS_Library.sh是否存在
function Check_Library()
{
	echo
	if [ ! -f $(pwd)/CentOS_Library.sh ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m当前目录:$(pwd),库文件(CentOS_Library.sh)不存在,程序无法继续执行!\033[0m"
		exit 90
	else
		echo -e ${INFOTime}"\033[34m当前目录:$(pwd),库文件(CentOS_Library.sh)存在,程序将开始执行!\033[0m"
		. CentOS_Library.sh
	fi
	echo
}
!

#更改YUM源
function Replace_YUM_Source()
{
	echo
	filename=/etc/yum.repos.d/CentOS-Base_backup.repo
	if [ ! -f ${filename} ];then
		echo -e ${INFOTime}"\033[34mThe \"${filename}\" does not exit,ready to copy now!\033[0m"
		#第一步：备份你的原镜像文件，以免出错后可以恢复。
		sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base_backup.repo
		Judge_Order 'sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base_backup.repo' 1
	fi
	filename=/etc/yum.repos.d/CentOS-Base.repo
	#第二步：下载新的CentOS-Base.repo 到/etc/yum.repos.d/
	wget -O ${filename} http://mirrors.aliyun.com/repo/Centos-6.repo
	Judge_Order "wget -O ${filename} http://mirrors.aliyun.com/repo/Centos-6.repo" 0
	#判断文件是否下载成功
	Judge_FileIsExist
	#更改CentOS-Media.repo使其为不生效：
	enabled=0
	Judge_Order 'enabled=0' 0
	#第三步：运行yum makecache生成缓存
	sudo yum clean all && yum makecache
	Judge_Order 'yum clean all && yum makecache' 0
	echo -e ${INFOTime}"\033[34mThe method \"Replace_YUM_Source()\" run success!\033[0m"
	echo
}
#添加新用户，禁止root用户登录
function Add_User()
{
	echo
	local Status=126,isRepeat=1
	#读取用户输入的用户名，并确保有效
	while [[ ${Status} -ne 0 ]]
	do
		#从键盘获取输入用户名
		read -t 30 -p "Please input a new username:" NewUser
		echo
		if [ -z "${NewUser}" ];then
			#如果用户在30s内未输入，则使用默认账号
			NewUser="zc"
			echo -e ${INFOTime}"\033[34mYou did not enter a new user name within 30 seconds\033[0m"
			echo -e ${INFOTime}"\033[34mThe system will use the default username :\033[0m\033[31m${NewUser}\033[0m"
		else
			echo -e ${INFOTime}"\033[34mThe username you entered is:\033[0m\033[33m${NewUser}\033[0m"	
		fi
		if id -u ${NewUser} >/dev/null 2>&1; then
			echo -e ${INFOTime}"\033[34mThe username :\033[0m\033[33m${NewUser}\033[0m\033[34m already exists\033[0m"
			isRepeat=0
			Status=0					
		else
			#添加用户
			sudo useradd ${NewUser}
			Status=${?}
			#判断用户名是否添加成功
			if [ ${Status} -ne 0 ];then 
				echo -e ${ERRORTime}"\033[31mThe user \"${NewUser}\" addition failed, please try again!\033[0m"
			fi
		fi
	done
	if [ ${isRepeat} -ne 0 ];then
		echo -e ${INFOTime}"\033[34mPlease set a password for ${NewUser}!\033[0m"
		#输入密码
		sudo passwd  ${NewUser}
		Judge_Order "passwd  ${NewUser}" 0
		#给新建用户赋权限,现在处理是超级管理员权限，后期可根据需要进行更改
		#su root
		filename=/etc/sudoers	
		#修改配置文件，添加下列行数
		Judge_Txt "${NewUser}\ ALL=(ALL)\ ALL"
		#sudo sed -i "/^root/a\\${NewUser}\ ALL=(ALL)\ ALL" ${filename}
		#Judge_Order "sudo sed -i \"/^root/a\\${NewUser}\ ALL=(ALL)\	ALL\" ${filename}" 0
	fi
	echo -e ${INFOTime}"\033[34mThe method \"Add_User()\" run success!\033[0m"
	echo
}
#禁止Root用户本地和远程登录
function Disable_Root_Login()
{
	echo
	filename=/etc/pam.d/login
	Judge_Txt 'auth required pam_succeed_if.so user != root quiet'
	filename=/etc/ssh/sshd_config
	#result=`grep -E -n ^PermitRootLogin ${filename} | cut -d ":" -f 1`
	Judge_Txt "PermitRootLogin.*" "PermitRootLogin no"
	sudo service sshd start
	Judge_Order 'sudo service sshd start' 1
	sudo service sshd restart
	Judge_Order 'sudo service sshd restart' 0	
	echo -e ${INFOTime}"\033[34mThe method \"Disable_Root_Login()\" run success!\033[0m"
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
		filename=/etc/sysconfig/iptables
		Judge_Txt "22" "${sshport}"
	else
		Judge_Txt "Port.*" "Port\ ${sshport}"
		filename=/etc/sysconfig/iptables
		Judge_Txt "${oldPort}" "${sshport}"
	fi
	sudo service sshd start
	Judge_Order 'sudo service sshd start' 1
	sudo service sshd restart
	Judge_Order 'sudo service sshd restart' 0	
	Description_Information "The old SSH port number is:${oldPort}" "The new SSH port number is:${sshport}"
	echo -e ${INFOTime}"\033[34mThe method \"Change_SSH_Port()\" run success!\033[0m"
	echo
}
#安装可视化桌面环境
function Install_Desktop_Environment()
{
	echo
	local XrdpPort=3389
	CheckOrInstall_Software 'yumgroup' 'Desktop'
	CheckOrInstall_Software 'yumgroup' 'X Window System'
	#安装一个中文支持:
	CheckOrInstall_Software 'yumgroup' 'Chinese Support'
	CheckOrInstall_Software 'yum' 'xrdp'
	#注意：CentOS安装，如果默认选择的是英文,需要修改/etc/sysconfig/i18n，将LANG修改为LANG="zh_CN.UTF-8"
	filename=/etc/sysconfig/i18n
	#将LANG修改为LANG="zh_CN.UTF-8" 
	Judge_Txt "en_US" "zh_CN"
	filename=/etc/sysconfig/iptables
	Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${XrdpPort} -j ACCEPT" 1
	sudo init 5
	Judge_Order "sudo init 5" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_Desktop_Environment()\" run success!\033[0m"
	echo
}
#安装VNCServer
function Install_VNCServer()
{
	echo
	local VNCServerPort=5901
	local VNCServerUser=root
	sudo yum install tigervnc-server -y
	Judge_Order "sudo yum install tigervnc-serverd -y" 0
	#CheckOrInstall_Software 'yum' 'tigervnc-server'
	#输入vncserver，初次启动的时候需要输入两次密码
	echo -e ${INFOTime}"\033[34mPlease input vncserver password(root)!\033[0m"
	sudo vncserver
	Judge_Order "vncserver" 0
	#修改相关配置文件
	filename=/etc/sysconfig/vncservers
	Judge_Txt "# VNCSERVERS.*" "VNCSERVERS=\"1:${VNCServerUser}\""
	# VNCSERVERARGS[2]="-geometry 800x600 -nolisten tcp -localhost"
	Judge_Txt "# VNCSERVERARGS\[2\]" "VNCSERVERARGS\[2\]"
	sudo vncserver
	Judge_Order "vncserver" 0
	filename=/etc/sysconfig/iptables
	#默认VNCserver端口号为：5901
	Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${VNCServerPort} -j ACCEPT" 1
	#重启vnc服务
	sudo service vncserver restart
	Judge_Order "sudo service vncserver restart" 0
	#设置开机自启动
	sudo chkconfig vncserver on
	Judge_Order "sudo chkconfig vncserver on" 0
	Description_Information "The user name of VNCServer is: ${VNCServerUser}" "The port number of VNCServer is: ${VNCServerPort}"
	echo -e ${INFOTime}"\033[34mThe method \"Install_VNCServer()\" run success!\033[0m"
	echo
}
#安装VSFTP
function Install_VSftp()
{
	echo
	local VsftpdPort=21
	CheckOrInstall_Software "yum" "vsftpd"
	sudo service vsftpd start
	Judge_Order "sudo service vsftpd start" 1
	filename=/etc/vsftpd/vsftpd.conf
	Judge_Txt "anonymous_enable.*" "anonymous_enable=NO"
	Judge_Txt "#xferlog_file" "xferlog_file"
	Judge_Txt "#idle_session_timeout" "idle_session_timeout"
	Judge_Txt "#data_connection_timeout" "data_connection_timeout"
        Judge_Txt "#ascii_upload.*" "ascii_upload_enable=YES"
	Judge_Txt "#ascii_download.*" "ascii_download_enable=YES"
	Judge_Txt "#ftpd_banner" "ftpd_banner"
	Judge_Txt "#chroot_local.*" "chroot_local_user=NO"
	Judge_Txt "#chroot_list_enable" "chroot_list_enable"
	Judge_Txt "#chroot_list_file" "chroot_list_file"
	sudo service vsftpd restart
	Judge_Order "sudo service vsftpd restart" 0
	filename=/etc/sysconfig/iptables
	Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${VsftpdPort} -j ACCEPT" 1
	sudo service iptables restart
	Judge_Order "sudo service iptables restart" 0
	sudo chkconfig vsftpd on
	Judge_Order "sudo chkconfig vsftpd on" 0
	Judge_Txt "SELINUX=.*" "SELINUX=enforcing"
	sudo service vsftpd restart
	Judge_Order "sudo service vsftpd restart" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_VSftp()\" run success!\033[0m"
	echo
}
function Create_Vsftp_User()
{
	echo
	local Status=126,isRepeat=1
	local newmkdir='/www',vsftpname='demo'
	#创建一个新的目录
	while [[ ${Status} -ne 0 ]]
	do
		read -t 30 -p "Please enter the name of the directory to be created(E.g www/test):" newmkdir
		echo
		if [ -z "${newmkdir}" ];then
			newmkdir='/www'
			echo -e ${INFOTime}"\033[34mYou did not enterthe name of the directory within 30 seconds\033[0m"
			echo -e ${INFOTime}"\033[34mThe system will use the default directory :\033[0m\033[31m${newmkdir}\033[0m"
		else
			newmkdir=${newmkdir}
			echo -e ${INFOTime}"\033[34mThe name of the directory you entered is:\033[0m\033[33m${newmkdir}\033[0m"	
		fi
		
		if [ ! -d ${newmkdir} ];then
			sudo mkdir -p ${newmkdir}
			Status=${?}
			if [ ${Status} -ne 0 ];then 
				echo -e ${ERRORTime}"\033[31mThe directory \"${newmkdir}\" create failed, please try again!\033[0m"
			fi
		else
			Status=0
			echo -e ${INFOTime}"\033[34mThe \"${newmkdir}\" directory already exists!\033[0m"	
		fi
	done
	Status=126
	#读取用户输入的用户名，并确保有效
	while [[ ${Status} -ne 0 ]]
	do
		#从键盘获取输入用户名
		read -t 30 -p "Please input a new vsftp username:" vsftpname
		echo
		if [ -z "${vsftpname}" ];then
			#如果用户在30s内未输入，则使用默认账号
			vsftpname="demo"
			echo -e ${INFOTime}"\033[34mYou did not enter a new user name within 30 seconds\033[0m"
			echo -e ${INFOTime}"\033[34mThe system will use the default username :\033[0m\033[31m${vsftpname}\033[0m"
		else
			echo -e ${INFOTime}"\033[34mThe username you entered is:\033[0m\033[33m${vsftpname}\033[0m"	
		fi
		if [ "$(id -u ${vsftpname} >/dev/null 2>&1)" = "0" ]; then
			echo -e ${INFOTime}"\033[34mThe vsftp username :\033[0m\033[33m${vsftpname}\033[0m\033[34m already exists\033[0m"
			isRepeat=0
			Status=0					
		else
			#添加用户
			sudo useradd -d ${newmkdir} -g ftp -s /sbin/nologin ${vsftpname}
			Status=${?}
			#判断用户名是否添加成功
			if [ ${Status} -ne 0 ];then 
				echo -e ${ERRORTime}"\033[31mThe vsftp user \"${vsftpname}\" addition failed, please try again!\033[0m"
			fi
		fi
	done
	sudo chown -R ${vsftpname} ${newmkdir}
	Judge_Order "sudo chmod -R ${vsftpname} ${newmkdir}" 0
	sudo chmod -R 777 ${newmkdir}
	Judge_Order "sudo chown -R 777 ${newmkdir}" 0
	echo -e ${INFOTime}"\033[34mPlease set a password for ${vsftpname}!\033[0m"
	sudo passwd ${vsftpname}
	Judge_Order "passwd ${vsftpname}" 0
	filename=/etc/vsftpd/chroot_list
	Judge_Txt "${vsftpname}" 
	sudo service vsftpd restart
	Judge_Order "sudo service vsftpd restart" 0
	echo -e ${INFOTime}"\033[34mThe method \"Create_Vsftp_User()\" run success!\033[0m"
	echo
}
#安装JDK
function Install_JDK()
{
	echo
	local java_home="\/usr\/lib\/jvm\/java-1.8.0-openjdk-1.8.0.*.x86_64"
	CheckOrInstall_Software 'yum' 'java-1.8.0-openjdk*'
	sudo chmod 755 /etc/profile
	filename=/etc/profile
	#根据实际的路径更改
	Judge_Txt "export JAVA_HOME=${java_home}"
	Judge_Txt "export JRE_HOME=\\\${JAVA_HOME}\/jre"
	Judge_Txt "export CLASSPATH=.:\\\${JAVA_HOME}\/lib:\\\${JRE_HOME}\/lib"
	Judge_Txt "export PATH=\\\${JAVA_HOME}\/bin:\\\${PATH}"
	source ${filename}
	Judge_Order "source ${filename}" 0
	java -version
	Judge_Order "java -version" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_JDK()\" run success!\033[0m"
	echo
}

function Install_XRDP()
{
	echo
	local XRDPPort=3389
	sudo yum install epel* -y
	Judge_Order "sudo yum install epel* -y" 0
	sudo yum install xrdp -y
	Judge_Order "sudo yum install xrdp -y" 0
	filename=/etc/sysconfig/iptables
	Judge_Txt "-A INPUT -j REJECT.*" "-A INPUT -m state --state NEW -m tcp -p tcp --dport ${XRDPPort} -j ACCEPT" 1
	sudo service iptables restart
	Judge_Order "sudo service iptables restart" 0
	sudo chkconfig xrdp on
	Judge_Order "sudo chkconfig xrdp on" 0
	sudo service xrdp start
	Judge_Order "sudo service xrdp start" 1
	sudo service xrdp restart
	Judge_Order "sudo service xrdp restart" 0
	Description_Information "The old SSH port number is:${oldPort}" "The new SSH port number is:${XRDPPort}"
	echo -e ${INFOTime}"\033[34mThe method \"Install_XRDP()\" run success!\033[0m"
	echo
}
#服务器是美国时间，可以更新为中国时间
function Update_Time()
{
	echo
	sudo yum  install ntp ntpdate -y
	Judge_Order "sudo yum  install ntp ntpdate -y" 0
	#修改为上海时区
	filename=/etc/sysconfig/clock
	Judge_Txt "UTC = false"
	Judge_Txt "ARC = false"
	#使文件修改生效
	sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	Judge_Order "sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime" 0
	#设置时间同步
	sudo ntpdate cn.pool.ntp.org
	Judge_Order "sudo ntpdate cn.pool.ntp.org" 0
	#系统时间写入硬件时间
	sudo hwclock --systohc
	Judge_Order "sudo hwclock --systohc" 0
	#强制系统时间写入 CMOS 中防止重启失效
	sudo hwclock -w
	Judge_Order "sudo hwclock -w" 0
	#设置定时任务同步时间
	sudo crontab -l > conf && echo "00 12 * * * /usr/sbin/ntpdate cn.pool.ntp.org" >> conf && sudo crontab conf && rm -f conf
	Judge_Order 'sudo crontab -l > conf && echo "00 12 * * * /usr/sbin/ntpdate cn.pool.ntp.org" >> conf && sudo crontab conf && rm -f conf' 0
	echo -e ${INFOTime}"\033[34mThe method \"Update_Time()\" run success!\033[0m"
	echo
}

function Main()
{
        
	#Step 1: call the Welcome() function
	Welcome
	#Step 2: Call the Replace_YUM_Source() function,replace YUM source.
	Software_Install "Replace_YUM_Source"
	#Step 3: Update software environment
	Update_ALL
	#Step 4: Add a new user
	Software_Install "Add_User"
	#Step 5: Disable root login for remote users
	Software_Install "Disable_Root_Login"
	#Step 6: Modify ssh port number
	Software_Install "Change_SSH_Port"
	#Step 7: Install the desktop environment
	Software_Install "Install_Desktop_Environment"
	Update_ALL
	#Step 8: Install VNCServer
	Software_Install "Install_VNCServer"
	Update_ALL
	#Step 9: Install Vsftp
	Software_Install "Install_VSftp"
	Update_ALL
	#Step 10: Create VSFTP user
	Software_Install "Create_Vsftp_User"
	#Step 11: Install JDK1.8
	Software_Install "Install_JDK"
	#Step 12: Update Time
	Software_Install "Update_Time"
	Update_ALL
	#Step 12: Install xrdp
	#Software_Install "Install_XRDP"
	sleep 5s
	sudo reboot
}
Main
