#! /bin/bash

function Install_Aira2(){
	aria2c --version
	if [ "${?}" -ne 0 ];then
		sudo apt-get install aria2 -y
		if [ ${?} -eq 0 ];then
			echo -e "\033[36maria2安装成功\033[0m"
		else
			echo "\033[36maria2 安装失败，脚本程序退出！\033[0m"
			exit 1
		fi
	fi
}

function Configuration()
{
	cd ${HOME}/Software
	if [ -d "$(pwd)/aria2" ];then
		sudo rm -rf $(pwd)/aria2
	fi
	#新建文件夹  
	mkdir $(pwd)/aria2    
	touch $(pwd)/aria2/aria2.session    #新建session文件
	chmod 755 $(pwd)/aria2/aria2.session    #设置aria2.session可写 
	chmod 755 $(pwd)/aria2/aria2.conf    #设置aria2.session可写 
	touch $(pwd)/aria2/aria2.conf    #创建配置文件
	echo "#＝＝＝＝＝＝＝＝＝文件保存目录自行修改" >> $(pwd)/aria2/aria2.conf
	echo "dir=$(pwd)/aria2/downloads"            >> $(pwd)/aria2/aria2.conf
	echo "disable-ipv6=true"                     >> $(pwd)/aria2/aria2.conf
	echo "#打开rpc的目的是为了给web管理端用" >> $(pwd)/aria2/aria2.conf
	echo "enable-rpc=true" >> $(pwd)/aria2/aria2.conf
	echo "rpc-allow-origin-all=true" >> $(pwd)/aria2/aria2.conf
	echo "rpc-listen-all=true" >> $(pwd)/aria2/aria2.conf
	echo "#rpc-listen-port=6800" >> $(pwd)/aria2/aria2.conf
	echo "#断点续传" >> $(pwd)/aria2/aria2.conf
	echo "continue=true" >> $(pwd)/aria2/aria2.conf
	echo "input-file=$(pwd)/aria2/aria2.session" >> $(pwd)/aria2/aria2.conf
	echo "save-session=$(pwd)/aria2/aria2.session" >> $(pwd)/aria2/aria2.conf
	echo "#最大同时下载任务数" >> $(pwd)/aria2/aria2.conf
	echo "max-concurrent-downloads=20" >> $(pwd)/aria2/aria2.conf
	echo "save-session-interval=120" >> $(pwd)/aria2/aria2.conf
	echo "# Http/FTP 相关" >> $(pwd)/aria2/aria2.conf
	echo "connect-timeout=120" >> $(pwd)/aria2/aria2.conf
	echo "#lowest-speed-limit=10K" >> $(pwd)/aria2/aria2.conf
	echo "#同服务器连接数" >> $(pwd)/aria2/aria2.conf
	echo "max-connection-per-server=10" >> $(pwd)/aria2/aria2.conf
	echo "#max-file-not-found=2" >> $(pwd)/aria2/aria2.conf
	echo "#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要" >> $(pwd)/aria2/aria2.conf
	echo "min-split-size=10M" >> $(pwd)/aria2/aria2.conf
	echo "#单文件最大线程数, 路由建议值: 5" >> $(pwd)/aria2/aria2.conf
	echo "split=10" >> $(pwd)/aria2/aria2.conf
	echo "check-certificate=false" >> $(pwd)/aria2/aria2.conf
	echo "#http-no-cache=true" >> $(pwd)/aria2/aria2.conf
	cat $(pwd)/aria2/aria2.conf
}
function Start_Aira2()
{
	#判断git软件是否安装
	declare -i num=0
	git --version
	gitStatus=${?}
	if [ ! "${gitStatus}" -eq 0 ];then
		gnome-terminal  -x bash -c "sh $(pwd)/Git_Install.sh;exec bash "
		while [ ! "${gitStatus}" -eq 0 ]
		do 
			sleep 2s
			git --version
			gitStatus=${?}
			$((num=num+1))
			if [ "${num}" -eq 5 ];then
				echo "Git安装失败，脚本程序退出！"
				exit 1	
			fi
		done
	fi
	git clone https://github.com/acgotaku/BaiduExporter.git $(pwd)/aria2/BaiduExporter
	#启动aria2 
	#sudo aria2c --conf-path=$(pwd)/aria2/aria2.conf
	#aria2后台运行
	#sudo aria2c --conf-path=$(pwd)/aria2/aria2.conf -D 
	#谷歌浏览器的百度云盘插件，网址：https://github.com/acgotaku/BaiduExporter
	#Chrome：点击设置 - > 扩展程序，将BaiduExporter.crx文件拖到页面，安装它，或检查开发者模式 - > 加载解压缩的扩展程序，导航到该chrome/release文件夹。
	#Firefox：打开：在Firefox中调试，单击“加载临时加载项”并导航到该chrome/release文件夹，选择manifest.json，然后单击“确定”。
	#终端已经运行起来aria2c,直接在浏览器里输入http://aria2c.com/ 
	#aria2控制台网址：http://aria2c.com/

}

Install_Aira2
Configuration
Start_Aira2
