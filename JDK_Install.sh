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

function Configuration_JDK()
{
	echo
	echo
	sudo chmod 755 /etc/profile
	#根据实际的路径更改
	filename=/etc/profile
	fileName=/etc/profile
	Judge_Txt "export\ JAVA_HOME=$(pwd)\/jdk1.8.0_221"
	Judge_Txt "export\ JRE_HOME=\${JAVA_HOME}\/jre"
	Judge_Txt "export\ CLASSPATH=.:\${JAVA_HOME}\/lib:\${JRE_HOME}\/lib"
	Judge_Txt "export\ PATH=\${JAVA_HOME}\/bin:\$PATH"
	#sudo chmod -x /etc/profile
	source /etc/profile 
	source /etc/profile 
	source /etc/profile 

	sudo chmod 775 ~/.profile
	filename=~/.profile
	fileName=~/.profile
	Judge_Txt "export\ JAVA_HOME=$(pwd)\/jdk1.8.0_221"
	Judge_Txt "export\ JRE_HOME=\${JAVA_HOME}\/jre"
	Judge_Txt "export\ CLASSPATH=.:\${JAVA_HOME}\/lib:\${JRE_HOME}\/lib"
	Judge_Txt "export\ PATH=\${JAVA_HOME}\/bin:\$PATH"
	sudo chmod -x ~/.profile
	source ~/.profile
	source ~/.profile
	source ~/.profile
	Judge_Order "Configuration_JDK()" 1
	echo
	echo
}


function JDK_Install()
{
	Check_Library
	CheckOrInstall_Software "dpkg" "java"
	Determine_SoftwareFold_Exist "JDK"
	cd ${HOME}/Software/JDK
	local filePath=${HOME}/桌面/Software/jdk.*.tar.gz
	if [ ! -f ${filePath} ];then
		echo -e ${ERRORTime}"\033[31mThe file \"${filePath}\" does not exist, the program is about to terminate execution!\033[0m"
		return 90	
	fi
	sudo cp ${filePath} jdk.tar.gz
	Judge_Order "sudo cp ${filePath} jdk.tar.gz" 0
:<<!
	count=$(ls *.tar.gz | wc -w)
	if [ "${count}" -gt 0 ];then
		cd ${HOME}
		rm -rf $(pwd)/Software/JDK
		mkdir $(pwd)/Software/JDK
		echo -e "[\033[36m$(pwd)/Software/JDK delete success!\033[0m"
		cd ${HOME}/Software/JDK		
	fi
	#用户名335134701@qq.com
	#密码Zc863855414
	#如果链接无法下载，请手动前往官网下载
	sudo wget https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.tar.gz?AuthParam=1561264448_3c49d7e263b3ff4804474b381c8c4a4a
	Judge_Order "jdk-8u211-linux-x64.tar.gz download success" "jdk-8u211-linux-x64.tar.gz download fail" 0
!
	count=$(ls *.tar.gz | wc -w)
	if [ "${count}" -eq 1 ];then
		jdkName=$(ls *.tar.gz)
		tar -zxvf $(pwd)/${jdkName}
		#根据实际的路径更改
		Configuration_JDK
		javac --version
		Judge_Order "javac --version" 0
		sudo rm -rf ${jdkName}
		Judge_Order "sudo rm -rf ${jdkName}" 0
	else
		echo -e "\033[31mThe file jdk-8u211-linux-x64.tar.gz is not existence!\033[0m"
		exit 127
	fi
	Judge_Order "JDK_Install()" 0	
}
JDK_Install
