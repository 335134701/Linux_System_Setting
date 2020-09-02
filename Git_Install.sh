#! /bin/bash

#第一步安装git
function Install_Git(){
	if [ -n "$(git version)" ]; then
		echo "git已安装!"
	else 
		sudo apt-get install git -y
		if [ ${?} -eq 0 ];then
			echo "------git安装已完成!"
		else	
			echo "------git安装异常，已退出脚本!"
		fi
	fi
}
#第二步，配置Git用户信息
function Configuration_User_Git()
{
	git config --global user.name "335134701"
	git config --global user.email "335134701@qq.com"
}
function Install_SSH()
{
	if [ -n "$(ps -e | grep sshd)" ]; then
		echo "------SSH已安装!"
	else 
		sudo apt-get install ssh -y
		if [ ${?} -eq 0 ];then
			echo "------SSH安装已完成!"
		else	
			echo "------git安装异常，已退出脚本!"
		fi
	fi

}
#第四步，生成SSH KEY（可以省略）
function Create_SSH_KEY(){
	ls -al ~/.ssh
	if [ ! ${?} -eq 0];then
		#生成 ssh key 过程中，会让你填写 passphrase，连按三次回车跳过即可
		ssh-keygen -t rsa -C "335134701@qq.com"
	fi
	cd ~/.ssh
	# id_rsa 为私钥，id_rsa.pub 为公钥
	#ls -al
	cat id_rsa.pub
	#登录 GitHub，打开 Personal settings 页面，选择 SSH and GPG keys 选项
	#Title 可以随意填写，Key 中填写刚从 id_rsa.pub 中cat的内容
	#添加 SSH key 之后，Linux 就可以通过 SSH 建立本地 Git 与 GitHub 的连接
}


Install_Git
Configuration_User_Git
#Install_SSH
#Create_SSH_KEY
