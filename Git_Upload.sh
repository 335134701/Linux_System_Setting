#! /bin/bash
function Upload_File()
{
	#提交更新，需要输入用户名和密码
	git push origin master:${Name}
}
#链接远程Github账户
function Connect_Github()
{
	#添加远程仓库 git remote add <名称> <URL>
	git remote add origin https://github.com/335134701/Linux_Shell.git
	#将远程仓库分支下载到本地当前branch中
	git fetch
	if [ ! "${?}" -eq 0 ];then
		echo "------远程仓库分支同步到本地失败！退出脚本程序！"
		exit 1
	fi
	#git fetch Git_Demo
	#查看本地和远程所有分支
	git branch -a
	#查看本地分支
	#git branch
	#将本地分支和远程分支关联
	git branch --set-upstream-to=origin/${Name} master
	if [ ! "${?}" -eq 0 ];then
		echo "------将本地分支和远程分支关联失败！退出脚本程序！"
		exit 1
	fi
	git pull
	if [ ! "${?}" -eq 0 ];then
		echo "------git pull失败！退出脚本程序！"
		exit 1
	fi
}
#将需要提交的文件添加到缓存区
function Add_Local_File()
{
	#查看当前git状态
	#git status
	#将文件的修改、文件的删除，添加到暂存区
	#git add -u
	#将文件的修改、文件的新建，添加到暂存区
	#git add .
	#将文件的修改、文件的删除、文件的新建，添加到暂存区
	git add -A
	#添加改动说明
	echo 
	echo
	read -t 20 -p "Input a text to describe the change:" txt
	if [ "${?}" -ne 0 ];then
		echo "Your input is timeout!"
		exit 127
	fi
	echo 
	echo
	git commit -m "$(date "+%Y-%m-%d %H:%M:%S") : ${txt}"	
}
Name=$(pwd)
Name=${Name##*/}
Add_Local_File
Connect_Github
Upload_File

