#! /bin/bash

#**********************************************************
# 错误代码说明：
	# 0:表示正确
	# 1:表示错误
	# 2:表示软件已经安装，安装方式dpkg 
	# 3:表示软件未安装，将要安装，安装方式dpkg
	# 80:表示实际输入参数与函数输入参数不匹配错误
	# 81:表示参数不匹配错误
	# 82:表示函数不存在错误
	# 90:表示文件不存在错误
	# 126:状态码初始位
	# 127:表示命令执行失败
#**********************************************************

INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
DEBUGTime="[\033[36m$(date +"%Y-%m-%d %T") Debug\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "


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
function Download_Lib()
{
	echo
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/ppl-0.10.2-11.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/ppl-0.10.2-11.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/cloog-ppl-0.15.7-1.2.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/cloog-ppl-0.15.7-1.2.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/mpfr-2.4.1-6.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/mpfr-2.4.1-6.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/cpp-4.4.6-4.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/cpp-4.4.6-4.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/kernel-headers-2.6.32-279.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/kernel-headers-2.6.32-279.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/glibc-common-2.12-1.80.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/glibc-common-2.12-1.80.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/glibc-2.12-1.80.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/glibc-2.12-1.80.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/glibc-headers-2.12-1.80.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/glibc-headers-2.12-1.80.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/glibc-devel-2.12-1.80.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/glibc-devel-2.12-1.80.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/libstdc++-4.4.6-4.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/libstdc++-4.4.6-4.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/libgomp-4.4.6-4.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/libgomp-4.4.6-4.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/gcc-4.4.6-4.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/gcc-4.4.6-4.el6.x86_64.rpm" 0
	wget -P ${dir} http://vault.centos.org/6.3/os/x86_64/Packages/gcc-c++-4.4.6-4.el6.x86_64.rpm
	Judge_Order "wget http://vault.centos.org/6.3/os/x86_64/Packages/gcc-c++-4.4.6-4.el6.x86_64.rpm" 0
	echo -e ${INFOTime}"\033[34mThe method \"Download_Lib()\" run success!\033[0m"
	echo
}
#${dir} G++安装
function Install_GCC()
{
	echo
	sudo rpm -Uh --force --nodeps ${dir}/ppl-0.10.2-11.el6.x86_64.rpm 
	Judge_Order "sudo rpm -Uh ${dir}/ppl-0.10.2-11.el6.x86_64.rpm " 0
	sudo rpm -Uh --force --nodeps ${dir}/cloog-ppl-0.15.7-1.2.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/cloog-ppl-0.15.7-1.2.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/mpfr-2.4.1-6.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/mpfr-2.4.1-6.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/cpp-4.4.6-4.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/cpp-4.4.6-4.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/kernel-headers-2.6.32-279.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/kernel-headers-2.6.32-279.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/glibc-2.12-1.80.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/glibc-2.12-1.80.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/glibc-common-2.12-1.80.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/glibc-common-2.12-1.80.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/glibc-headers-2.12-1.80.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/glibc-headers-2.12-1.80.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/glibc-devel-2.12-1.80.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/glibc-devel-2.12-1.80.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/libstdc++-4.4.6-4.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/libstdc++-4.4.6-4.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/libgomp-4.4.6-4.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/libgomp-4.4.6-4.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/gcc-4.4.6-4.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/gcc-4.4.6-4.el6.x86_64.rpm" 0
	sudo rpm -Uh --force --nodeps ${dir}/gcc-c++-4.4.6-4.el6.x86_64.rpm
	Judge_Order "sudo rpm -Uh --force --nodeps ${dir}/gcc-c++-4.4.6-4.el6.x86_64.rpm" 0
	echo -e ${INFOTime}"\033[34mThe method \"Install_GCC()\" run success!\033[0m"
	echo
}

function Main()
{
	dir=${HOME}/GCC
	rm -rf ${dir}
	mkdir -p ${dir}
	#下载库文件
	Download_Lib
	#安装GCC G++
	Install_GCC
	rm -rf ${dir}
}
Main