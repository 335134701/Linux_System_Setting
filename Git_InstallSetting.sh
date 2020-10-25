#! /bin/bash

function Configuration()
{
	#========================================
	#需要更改的参数
	#用户名
	username=zc
	#邮箱
	useremail=335134701@qq.com
	#========================================
	git config --global user.name "${username}"
	git config --global user.email "${useremail}"
	git config --global color.ui auto
	#设置SSH Key
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Enter file in which to save the key (/home/zc/.ssh/id_rsa):(按下回车键)"
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Enter passphrase (empty for no passphrase):(输入github网站个人账户的密码)"
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""Enter same passphrase again: (再输一次github网站个人账户的密码)"
	ssh-keygen -t rsa -C ${useremail}
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""1.复制下面的哈希值;"
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""2.打开github网站并登录;" 
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""3.点击个人头像->Settings->SSH and GPG keys->New SSH key;" 
	echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""4.Title可以随便写，将复制的内容填入Key中."
	cat ~/.ssh/id_rsa.pub
	read -p "请确认Github网站操作是否完成(Y/N) ? " ischoose
	if [ ${ischoose} = "Y" -o ${ischoose} = "y" ];then
		ssh -T git@github.com
		echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""出现Hi 335134701! You've successfully authenticated, but GitHub does not provide shell access.表示成功!"
		echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""如果出现错误:sign_and_send_pubkey: signing failed: agent refused operation Permission denied (publickey)."
		echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""请执行如下操作:"
		echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "'1.eval "$(ssh-agent -s)"'
		echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""2.ssh-add"
		
	else
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  操作失败，程序结束!"
	fi

}
sudo apt-get install git -y
Configuration
