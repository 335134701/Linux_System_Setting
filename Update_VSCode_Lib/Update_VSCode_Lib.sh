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

function Welcome()
{
	echo
	echo
	echo
	echo -e "\033[34m*****************************************************\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	((num=28-${#0}))
	if [ ${num} -gt 0 ];then
		echo -e "\033[34m**          Welcome to \033[0m\033[33m${0}\c\033[0m"
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
#下载库函数
function Wget_Lib()
{
	echo 
	echo -e ${INFOTime}"The Method \" Wget_Lib() \" starts execution!"
	# Update glibc and static libs
	wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-2.17-55.el6.x86_64.rpm" 0
	wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-common-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir}://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-common-2.17-55.el6.x86_64.rpm" 0
	wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-devel-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-devel-2.17-55.el6.x86_64.rpm" 0
	wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-headers-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-headers-2.17-55.el6.x86_64.rpm" 0
	wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-utils-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-utils-2.17-55.el6.x86_64.rpm" 0
	wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-static-2.17-55.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-static-2.17-55.el6.x86_64.rpm" 0
	
	# Update libstdc++
	wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-4.8.2-16.3.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-4.8.2-16.3.el6.x86_64.rpm" 0
	wget -P ${dir}  https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-devel-4.8.2-16.3.el6.x86_64.rpm
	Judge_Order "wget -P ${dir}  https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-devel-4.8.2-16.3.el6.x86_64.rpm" 0
	wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-static-4.8.2-16.3.el6.x86_64.rpm
	Judge_Order "wget -P ${dir} https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-static-4.8.2-16.3.el6.x86_64.rpm" 0
	echo -e ${INFOTime}"The Method \" Wget_Lib() \" ends!"
	echo
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
function Main()
{
	local isChoose=0
	#第一步:欢迎界面
	Welcome
	#第二步:选择在线安装还是离线安装
	echo
    echo -e ${WARNTime}"Tips:下面程序运行过程中，如果输入错误，将按照默认选项执行!"
	sleep 3s
	echo
    read -t 5 -n 1 -p "Please choose to install Online or Offline(O/F Default:Offline):" isOnline
    echo
   	if [ ${isOnline} = "F" -o ${isOnline} = "f" ];then
        isOnline="F"
        echo -e ${INFOTime}"According to your choice, Frp will be installed offline!"
    else
        isOnline="O"
        echo -e ${INFOTime}"According to your choice, Frp will be installed online!"
    fi
	#第三步:创建目录,如果选择离线安装，需要输入文件所在的目录
	sudo rm -rf ${HOME}/VSCode_Lib/
	mkdir -p ${HOME}/VSCode_Lib
	if [ ${isOnline} = "O" ];then
        dir=${HOME}/VSCode_Lib
        Wget_Lib
    else
        while [ ${isChoose} -eq 0 ];
        do
            read -t 30 -p "Please enter the directory where the frp compressed package is located(eg:/demo):" dir
            if [ -n "$(ls ${dir}/*.rpm)" ];then
               isChoose=1
               echo -e ${INFOTime}"The files is existence!"
               break
            fi
            echo -e ${WARNTime}"The files is not existence!"
        done
    fi
	cp -r ${dir}/* ${HOME}/VSCode_Lib/
	Judge_Order "cp -r ${dir}/* ${HOME}/VSCode_Lib/" 0
	dir=${HOME}/VSCode_Lib
	#第四步:更新软件环境
	Update_ALL
	#第五步:进行安转
	sudo rpm -Uh --force --nodeps \
		${dir}/glibc-2.17-55.el6.x86_64.rpm \
		${dir}/glibc-common-2.17-55.el6.x86_64.rpm \
		${dir}/glibc-devel-2.17-55.el6.x86_64.rpm \
		${dir}/glibc-headers-2.17-55.el6.x86_64.rpm \
		${dir}/glibc-static-2.17-55.el6.x86_64.rpm \
		${dir}/glibc-utils-2.17-55.el6.x86_64.rpm
	sudo rpm -Uh \
		${dir}/libstdc++-4.8.2-16.3.el6.x86_64.rpm \
		${dir}/libstdc++-devel-4.8.2-16.3.el6.x86_64.rpm \
		${dir}/libstdc++-static-4.8.2-16.3.el6.x86_64.rpm
	#第六步:删除安装包
	sudo rm -rf ${dir}/
	echo -e ${INFOTime}"VSCode lib install success!"
}
Main