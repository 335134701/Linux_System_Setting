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

#卸载Ubuntu默认，无用软件
function Remove_Unusing_Software()
{
	#libreoffice
	sudo apt-get remove libreoffice* -y
	Judge_Order "sudo apt-get remove libreoffice* -y" 1
	sudo apt-get remove libreoffice-common libreoffice -y
	Judge_Order "sudo apt-get remove libreoffice-common libreoffice -y" 1
	sudo apt-get remove unity-webapps-common Amazon -y
	Judge_Order "sudo apt-get remove unity-webapps-common Amazon -y" 1
	sudo apt-get remove thunderbird -y
	Judge_Order "sudo apt-get remove thunderbird -y" 1
	sudo apt-get remove totem -y
	Judge_Order "sudo apt-get remove totem -y" 1
	sudo rm -f /usr/share/applications/com.canonical.launcher.amazon.desktop
	sudo rm -f /usr/share/applications/ubuntu-amazon-default.desktop
	Judge_Order "sudo rm -f /usr/share/applications/ubuntu-amazon-default.desktop" 1
	sudo apt-get remove simple-scan -y
	Judge_Order "sudo apt-get remove simple-scan -y" 1
	sudo apt-get remove hplip* -y
	Judge_Order "sudo apt-get remove hplip* -y" 1
	sudo apt-get remove printer-driver* -y
	Judge_Order "sudo apt-get remove printer-driver* -y" 1
	sudo apt-get remove rhythmbox* -y
	Judge_Order "sudo apt-get remove rhythmbox* -y" 1	
	sudo apt-get remove mahjongg -ysudo apt-get remove rhythmbox* -y
	Judge_Order "sudo apt-get remove mahjongg -ysudo apt-get remove rhythmbox* -y" 1
	sudo apt-get remove aisleriot -y
	Judge_Order "sudo apt-get remove aisleriot -y" 1
	sudo apt-get remove gnome-sudoku -y
	Judge_Order "sudo apt-get remove gnome-sudoku -y" 1
	sudo apt-get remove gnomine -y
	Judge_Order "sudo apt-get remove gnomine -y" 1
	sudo apt-get remove wodim -y
	Judge_Order "sudo apt-get remove wodim -y" 1
	sudo apt-get remove gnome-software -y
	Judge_Order "sudo apt-get remove gnome-software -y" 1
	Judge_Order "Remove_Unusing_Software()" 1
}
#更改默认配置函数
function Default_Configuration()
{
	echo
	echo
	#设置为no，更改默认dash为bash
	sudo dpkg-reconfigure dash
	fileName='/etc/default/grub'
	#设置双系统默认等待时间为5s
	if [ -f "${fileName}" ];then
		sudo chmod 755 ${fileName}
		#设置进入GRUB选择界面后默认等待时间5S
		sed -i 's/'"^GRUB_TIMEOUT.*/GRUB_TIMEOUT=5"'/g' ${fileName}
		Judge_Order "sed -i 's/'\"^GRUB_TIMEOUT.*/GRUB_TIMEOUT=5\"'/g' ${fileName}" 1
		#设置默认选择系统选项
		sed -i 's/'"^GRUB_DEFAULT.*/GRUB_DEFAULT=4"'/g' ${fileName}
		Judge_Order "sed -i 's/'\"^GRUB_DEFAULT.*/GRUB_DEFAULT=4\"'/g' ${fileName}" 1
		sudo chmod -x /etc/default/grub
		sudo update-grub
	else  
		echo -e "\033[31mThe file ${fileName} is not existence!\033[0m"
	fi
	fileName='/etc/default/apport'
	#设置不提醒系统错误
	if [ -f "${fileName}" ];then
		sudo chmod 755 ${fileName}
		sed -i 's/'"^enabled.*/enabled=0"'/g' ${fileName}
		Judge_Order "sed -i 's/'\"^enabled.*/enabled=0\"'/g' ${fileName}" 1
		sudo chmod -x ${fileName}
	else  
		echo -e "\033[31mThe file ${fileName} is not existence!\033[0m"
	fi	
	fileName='/usr/share/lightdm/lightdm.conf.d/50-guest-wrapper.conf'
	if [ -f "${fileName}" ];then
		sudo chmod 755 ${fileName}
		result=`sudo grep -E -n ^"allow-guest" ${fileName}` 
		if [ -z "${result}" ];then
			sudo sed -i \$a"allow-guest=false"  ${fileName}
		else
			sed -i 's/'"^allow-guest.*/allow-guest=false"'/g' ${fileName}
		fi
		sudo chmod -x ${fileName}
	else
		echo -e "\033[31mThe file ${fileName} is not existence!\033[0m"
	fi
	fileName=/boot/grub/grub.cfg
	echo -e "[\033[31m$(date +"%Y-%m-%d %T") Warn\033[0m]  ""\033[31m如果想减少开机界面GRUB选项,请删除问${filename}中以menuentry开头的部分内容，具体请详看${filename}文件!\033[0m"
	Judge_Order "Default_Configuration()" 1
	echo
	echo
	#删除多余的引导选项
	#修改文件/boot/grub/grub.cfg
        #以menuentry开头的即为引导项
	
}
function Chang_YUM(){ Run_SHFile "$(pwd)/Chang_YUM.sh" }
function Default_Software_Install(){ Run_SHFile "$(pwd)/Default_Software_Install.sh" }
function Sougou_Install(){ Run_SHFile "$(pwd)/Sougou_Install.sh" }
function Chrome_Install(){ Run_SHFile "$(pwd)/Chrome_Install.sh" }
function JDK_Install(){ Run_SHFile "$(pwd)/JDK_Install.sh" }
function Systembach_Install()
{
	sudo add-apt-repository ppa:nemh/systemback -y
	Judge_Order "sudo add-apt-repository ppa:nemh/systemback -y" 0
	sudo apt-get -y update && sudo apt-get install systemback unionfs-fuse -y
	Judge_Order "sudo apt-get -y update && sudo apt-get install systemback unionfs-fuse -y" 0
	Judge_Order "Systembach_Install()" 1
}
function QT_Install(){ Run_SHFile "$(pwd)/QT_Install.sh" }
function Main()
{
	#Step 1: 校验库文件是否存在
	Check_Library
	#Step 2: 执行欢迎函数
	Welcome
	sleep 1s
	#Step 3:更换YUM
	Software_Install "Chang_YUM"
	#Step 4:执行卸载Ubuntu自带软件函数
	Software_Install "Remove_Unusing_Software"
	#Step 5:安装一些需要默认的软件，例如vim
	Software_Install "Default_Software_Install"
	#Step 6:安装搜狗拼音输入法
	Software_Install "Sougou_Install"
	#Step 7:安装谷歌浏览器
	Software_Install "Chrome_Install"
	#Step 8:安装JDK
	Software_Install "JDK_Install"
	#Step 9:安装系统镜像制作软件
	Software_Install "Systembach_Install"
	#Step 10:安装QT
	Software_Install "QT_Install"
	
}
Main
