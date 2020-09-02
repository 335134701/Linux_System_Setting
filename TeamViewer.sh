#! /bin/bash


INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "
NewUser=${USER}

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
#更新软件
function Update_All()
{
	echo
	echo
	sudo apt-get upgrade -y
	Judge_Order "sudo apt-get upgrade -y" 1
	sudo apt-get update -y
	Judge_Order "sudo apt-get update -y" 1
	sudo apt-get -f install -y
	Judge_Order "sudo apt-get -f install -y" 1
	sudo apt-get autoremove -y
	Judge_Order "sudo apt-get autoremove -y" 1
	Judge_Order "Update_All()" 1
	echo
	echo
}

#更新软件
function Update_All()
{
	echo
	echo
	sudo apt-get upgrade -y
	Judge_Order "sudo apt-get upgrade -y" 1
	sudo apt-get update -y
	Judge_Order "sudo apt-get update -y" 1
	sudo apt-get -f install -y
	Judge_Order "sudo apt-get -f install -y" 1
	sudo apt-get autoremove -y
	Judge_Order "sudo apt-get autoremove -y" 1
	Judge_Order "Update_All()" 1
	echo
	echo
}
#判断对应的目录是存在
function  Determine_SoftwareFold_Exist()
{
	echo
	echo
	if [ ${#} -eq 1 ];then
		if [ -d "${HOME}/Software" ];then
			echo -e "\033[36m${HOME}/Software already exist!\033[0m"
		else
			mkdir ${HOME}/Software
			echo -e "\033[36m${HOME}/Software create success!\033[0m"	
		fi
		if [ -d "${HOME}/Software/${1}" ];then
			echo -e "\033[36m${HOME}/Software/${1} already exist!\033[0m"
		else
			mkdir ${HOME}/Software/${1}
			echo -e "\033[36m${HOME}/Software/${1} create success!\033[0m"	
		fi
	else
		echo -e "\033[31mThe method \"Determine_SoftwareFold_Exist()\" unction parameter input is incorrect, please re-enter!\033[0m"
	fi
	Judge_Order "Determine_SoftwareFold_Exist()" 1
	echo
	echo
}
#判断软件是否安装
function SoftwareIsInstall()
{
	echo
	echo
	${1} -version
	local Software_version=${?}
	if [ ${#} -eq 1 ];then
		if [ ${Software_version} -eq 0 ];then
			echo -e "[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[33m\"${1}\" ""aleredy install!\033[0m"
			echo
			echo
			exit 0
		else
			echo -e "[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[36m\"${1}\" ""will be installed!\033[0m"
		fi
	else
		echo -e "\033[31mThe method \"SoftwareIsInstall()\" unction parameter input is incorrect, please re-enter!\033[0m"
	fi
	Judge_Order "SoftwareIsInstall()" 1
	echo
	echo
}


function Teamviewer_Insall()
{
	SoftwareIsInstall "teamviewer"
	Determine_SoftwareFold_Exist "Teamviewer"
	cd ${HOME}/Software/Teamviewer
	count=$(ls *.deb | wc -w)
	if [ ${count} -gt 0 ];then
		cd ${HOME}
		rm -rf ${HOME}/Software/Teamviewer
		mkdir ${HOME}/Software/Teamviewer
		echo -e "\033[36m${HOME}/Software/Teamviewer recreate success\033[0m"
		cd ${HOME}/Software/Teamviewer	
	fi
	wget https://dl.teamviewer.cn/download/linux/version_14x/teamviewer_14.4.2669_amd64.deb
	Judge_Order "wget https://dl.teamviewer.cn/download/linux/version_14x/teamviewer_14.4.2669_amd64.deb" 0
	Update_All
	sudo dpkg -i teamviewer_14.4.2669_amd64.deb
	Judge_Order "sudo dpkg -i teamviewer_14.4.2669_amd64.deb" 1
	Update_All
	sudo dpkg -i teamviewer_14.4.2669_amd64.deb
	Judge_Order "sudo dpkg -i teamviewer_14.4.2669_amd64.deb" 0
	sudo dpkg -l teamviewer
	Judge_Order "sudo dpkg -l teamviewer" 0
	rm -rf teamviewer_14.4.2669_amd64.deb
	Judge_Order "rm -rf teamviewer_14.4.2669_amd64.deb" 0
	Judge_Order "Teamviewer_Insall()" 0
}
Teamviewer_Insall




