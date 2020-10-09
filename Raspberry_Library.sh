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
	# 6.开机自启动SSH:
	# 7.开机自启动VNC:
	# 8.设置中文环境:
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
	echo -e "\033[34m********************************************************************************\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m**  初始化界面设置相关操作:                                                   **\033[0m"
	echo -e "\033[34m**      1.开启SSH:系统烧录完成后,在SD卡根目录新建SSH文件                      **\033[0m"
	echo -e "\033[34m**      2.获取树莓派IP,SSH连接树莓派:User:pi;Passwd:raspberry                 **\033[0m"
	echo -e "\033[34m**      3.输入命令vncserver,可临时远程界面VNC Viewer连接                      **\033[0m"
	echo -e "\033[34m**      4.打开vnc viewer,配置:VNC Server: IP:5900/5901; Name:pi               **\033[0m"
	echo -e "\033[34m**      5.连接成功,打开命令行,输入:sudo raspi-config                          **\033[0m"
	echo -e "\033[34m**      6.开机自启动SSH:                                                      **\033[0m"
	echo -e "\033[34m**      7.开机自启动VNC:                                                      **\033[0m"
	echo -e "\033[34m**      8.设置中文环境:                                                       **\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m**                                                                            **\033[0m"
	echo -e "\033[34m********************************************************************************\033[0m"
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
function Run_SHFile()
{
	if [ -f ${1} ];then
		sudo chmod 755 ${1}
		${1}
		Judge_Order "${1}" 1
	else
		echo -e "\033[31mThe file ${1} is not existence!\033[0m"
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