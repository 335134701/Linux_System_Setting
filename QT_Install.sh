#! /bin/bash
#校验库文件Ubuntu_Library.sh是否存在
function Check_Library()
{
	echo
	if [ ! -f $(pwd)/Ubuntu_Library.sh ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m当前目录:$(pwd),库文件(Ubuntu_Library.sh)不存在,程序无法继续执行!\033[0m"
		exit 90
	else
		echo -e ${INFOTime}"\033[34m当前目录:$(pwd),库文件(Ubuntu_Library.sh)存在,程序将开始执行!\033[0m"
		. Ubuntu_Library.sh
	fi
	echo
}

function QT_Configuration()
{

	echo
	echo
	sudo chmod 777 /usr/lib/x86_64-linux-gnu/qt-default
	sudo chmod 777 /usr/lib/x86_64-linux-gnu/qt-default/qtchooser

	filename=/usr/lib/x86_64-linux-gnu/qt-default/qtchooser/default.conf
	sudo touch ${fileName}
	sudo chmod 777 ${fileName}
	echo "#This is ${fileName}" >> ${fileName}
	Judge_Txt "$(pwd)\/5.9.0\/gcc_64\/bin"  
 	Judge_Txt "$(pwd)\/5.9.0\/" 
	  
	sudo chmod 755 /etc/profile
	filename=/etc/profile
	fileName=/etc/profile
	Judge_Txt "export\ PATH=$(pwd)\/Tools\/QtCreator\/bin:\$PATH"
	Judge_Txt "export\ PATH=$(pwd)\/5.9.0\/gcc_64\/bin:\$PATH"
	Judge_Txt "export\ LD_LIBRARY_PATH=$(pwd)\/5.9.0\/gcc_64\/lib:\$LD_LIBRARY_PATH"
	sudo chmod -x /etc/profile
	source /etc/profile 
	
	sudo chmod 755 ~/.profile
	filename=~/.profile
	fileName=~/.profile
	Judge_Txt "export\ PATH=$(pwd)\/Tools\/QtCreator\/bin:\$PATH"
	Judge_Txt "export\ PATH=$(pwd)\/5.9.0\/gcc_64\/bin:\$PATH"
	Judge_Txt "export\ LD_LIBRARY_PATH=$(pwd)\/5.9.0\/gcc_64\/lib:\$LD_LIBRARY_PATH"
	sudo chmod -x ~/.profile
	source ~/.profile

	sudo chmod 755 ~/.bashrc
	filename=~/.bashrc
	fileName=~/.bashrc
	Judge_Txt "export\ PATH=$(pwd)\/Tools\/QtCreator\/bin:\$PATH"
	sudo chmod -x ~/.bashrc
	source ~/.bashrc
	Judge_Order "QT_Configuration()" 1
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
function QT_Install()
{
	Check_Library
	SoftwareIsInstall "qtcreator"
	Determine_SoftwareFold_Exist "QT"
	#QT下载网址：http://download.qt.io/archive/qt/
	cd ${HOME}/Software/QT
	local filePath=${HOME}/桌面/Software/qt-opensource-linux-x64-5.9.0.run
	if [ ! -f ${filePath} ];then
		echo -e ${ERRORTime}"\033[31mThe file \"${filePath}\" does not exist, the program is about to terminate execution!\033[0m"
		return 90	
	fi
	sudo cp ${filePath} qt.run
	Judge_Order "sudo cp ${filePath} qt.run" 0
:<<!
	count=$(ls *.run | wc -w)
	if [ ${count} -gt 0 ];then
		cd ${HOME}
		rm -rf ${HOME}/Software/QT
		mkdir ${HOME}/Software/QT
		echo -e "\033[36m$(pwd)/Software/QT recreate success!\033[0m"
		cd ${HOME}/Software/QT		
	fi
	#如果链接更改，更改对应的目录名即可
	wget http://mirrors.ustc.edu.cn/qtproject/archive/qt/5.9/5.9.0/qt-opensource-linux-x64-5.9.0.run
	Judge_Order "http://mirrors.ustc.edu.cn/qtproject/archive/qt/5.9/5.9.0/qt-opensource-linux-x64-5.9.0.run" 0	
!
	count=$(ls *.run | wc -w)
	if [ ${count} -eq 1 ];then
		Update_All
		exeName=$(ls *.run)
		sudo chmod 755 ${exeName}
		./${exeName}
		Judge_Order "${exeName} install" 0
		sudo rm -rf ${exeName}
		Judge_Order "sudo rm -rf ${exeName}" 1
		QT_Configuration
	else
		echo -e "\033[31mThe file qt.run is not existence\033[0m"
	fi
	Judge_Order "QT_Install()" 0
	#sudo reboot
}
QT_Install


