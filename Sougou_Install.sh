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
function Sougou_Install()
{
	Check_Library
	#判断软件是否安装
	CheckOrInstall_Software "dpkg" "sogoupinyin"
	#判断Software目录是否存在
	Determine_SoftwareFold_Exist "Sougou"
	cd ${HOME}/Software/Sougou
	local filePath=${HOME}/Desktop/Software/sogoupinyin_*.deb
	if [ ! -f ${filePath} ];then
		echo -e ${ERRORTime}"\033[31mThe file \"${filePath}\" does not exist, the program is about to terminate execution!\033[0m"
		return 90	
	fi
	sudo cp ${filePath} sogoupinyin.deb 
	Judge_Order "sudo cp ${filePath} sogoupinyin.deb " 0
:<<!
	count=$(ls *.deb | wc -w)
	if [ "${count}" -gt 0 ];then
		cd ${HOME}/Software
		rm -rf $(pwd)/Software/Sougou
		mkdir $(pwd)/Software/Sougou
		echo -e "\033[36m$(pwd)/Software/Sougou delete success!\033[0m"
		cd ${HOME}/Software/Sougou		
	fi
	#更新软件
	#Update_All
	#搜狗官网：http://pinyin.sogou.com/linux/
	#根据电脑配置选择32位或者64位
	wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb&e=1561214859&fn=sogoupinyin_2.2.0.0108_amd64.deb
	Judge_Order "wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb&e=1561214859&fn=sogoupinyin_2.2.0.0108_amd64.deb" 0
!
	#sogoupinyin_2.2.0.0108_amd64.deb可由下载链接看出
	count=$(ls *.deb | wc -w)
	if [ ${count} -eq 1 ];then
		Update_All
		sudo dpkg -i sogoupinyin.deb
		Judge_Order "sudo dpkg -i sogoupinyin.deb" 1
		Update_All
		sudo dpkg -i sogoupinyin.deb
		Judge_Order "sudo dpkg -i sogoupinyin.deb" 0
		sudo rm -rf sogoupinyin.deb
		Judge_Order "sudo rm -rf sogoupinyin.deb" 0
	else 
		echo -e "\033[31mThe file sogoupinyin.deb is not existence!\033[0m"
		exit 127	
	fi
	Judge_Order "Sougou_Install()" 0
	#余下操作部分可查看网址：https://blog.csdn.net/areigninhell/article/details/79696751	
	#输入法设置命令行输入：fcitx-configtool
}

Sougou_Install
