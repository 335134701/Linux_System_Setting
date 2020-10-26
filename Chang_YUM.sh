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
function Change_YUM()
{
	Check_Library
	filename=/etc/apt/sources.list
	#修改yum
	sudo chmod 755 ${filename}
	#删除文本每行首#
	#sudo sed -i "s/^#//" /etc/apt/sources.list
	#sudo awk '{print "#"$0 > "/etc/apt/sources.list"}' /etc/apt/sources.list
	#deb http://cn.archive.ubuntu.com/ubuntu/ xenial main restricted
	#注释掉默认的源
	result=`grep -E -n ^'deb http://cn.archive.ubuntu.com/ubuntu/ xenial main restricted=' ${filename}`
	if [ -n "${result}" ];then
		sudo sed -i "s/^/#/g" ${filename}
	fi
	#替换为阿里源
	#Judge_Txt "#阿里云"
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial main'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial main'
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main'
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial universe'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe'
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe'
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial-security main'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main'
	Judge_Txt 'deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe'
	Judge_Txt 'deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe'


	#deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
	#deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
	#deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
	#deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
	#deb http://mirrors.aliyun.com/ubuntu/ xenial universe
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
	#deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
	#deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
	#deb http://archive.canonical.com/ubuntu xenial partner
	#deb-src http://archive.canonical.com/ubuntu xenial partner
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
	#deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
	#deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse

	#新安装的Ubuntu在使用sudo apt-get update更新源码的时候出现如下错误：
	#W: GPG 错误：http://mirrors.ustc.edu.cn/ros/ubuntu xenial InRelease: 由于没有公钥，无法验证下列签名： NO_PUBKEY F42ED6FBAB17C654
	#W: 仓库 “http://mirrors.ustc.edu.cn/ros/ubuntu xenial InRelease” 没有数字签名。
	#N: 无法认证来自该源的数据，所以使用它会带来潜在风险。
	#N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
	#解决方法很简单，下载导入公钥就行，下载导入key的命令如下：
	#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654 #此处F42ED6FBAB17C654需要是错误提示的key
}
Change_YUM



