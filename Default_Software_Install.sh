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
function Default_Software_Install()
{
	Check_Library
	CheckOrInstall_Software "apt-get" vim
	CheckOrInstall_Software "apt-get" wget
	CheckOrInstall_Software "apt-get" tcpdump
	CheckOrInstall_Software "apt-get" wireshark
	CheckOrInstall_Software "apt-get" cmake
}
Default_Software_Install
