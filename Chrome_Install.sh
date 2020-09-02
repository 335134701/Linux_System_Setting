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

function Chrome_Install()
{
	Check_Library
	CheckOrInstall_Software "dpkg" "google-chrome"
	Determine_SoftwareFold_Exist "Chrome"
	cd ${HOME}/Software/Chrome
	count=$(ls *.deb | wc -w)
	if [ "${count}" -gt 0 ];then
		cd ${HOME}
		rm -rf ${HOME}/Software/Chrome
		mkdir ${HOME}/Software/Chrome
		echo -e "[\033[36m$(pwd)/Software/Chrome delete success!\033[0m"
		cd ${HOME}/Software/Chrome		
	fi
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	Judge_Order "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" 0
	count=$(ls *.deb | wc -w)
	if [ ${count} -eq 1 ];then
		Update_All
		sudo dpkg -i google-chrome*
		Judge_Order "sudo dpkg -i google-chrome*" 0
		#实现命令行输入chrome即可启动谷歌浏览器
		filename=${HOME}/.bashrc
		Judge_Txt "export\ PATH=\/opt\/google\/chrome:\$PATH"
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
		Judge_Order "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654" 1
		sudo rm -rf google-chrome-stable_current_amd64.deb
		Judge_Order "sudo rm -rf google-chrome-stable_current_amd64.deb" 1
	else 
		echo -e "\033[31mThe file google-chrome-stable_current_amd64.deb is not existence!\033[0m"	
	fi
	Judge_Order "Chrome_Install()" 0
}
Chrome_Install
#运行谷歌浏览器
/usr/bin/google-chrome-stable

#如果出现下列问题
#W: GPG 错误：https://dl.google.com/linux/chrome/deb stable Release: 由于没有公钥，无法验证下列签名： NO_PUBKEY 1397BC53640DB551
#E: 仓库 “https://dl.google.com/linux/chrome/deb stable Release” 没有数字签名。
#N: 无法安全地用该源进行更新，所以默认禁用该源。
#N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
#W: GPG 错误：https://repo.fdzh.org/chrome/deb stable Release: 由于没有公钥，无法验证下列签名： NO_PUBKEY 1397BC53640DB551
#E: 仓库 “https://repo.fdzh.org/chrome/deb stable Release” 没有数字签名。
#N: 无法安全地用该源进行更新，所以默认禁用该源。
#N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
#

#输入下列命令解决
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1397BC53640DB551 #1397BC53640DB551更改为自己出现的错误

