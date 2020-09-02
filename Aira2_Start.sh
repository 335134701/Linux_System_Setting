#! /bin/bash

#aria2后台运行
sudo aria2c --conf-path=$(pwd)/aria2/aria2.conf -D 
#aria2控制台网址：http://aria2c.com/
#打开默认浏览器，浏览网址：http://aria2c.com/
#x-www-browser "http://aria2c.com/"
google-chrome --verision
if [ "${?}" -eq 0 ];then
	google-chrome "http://aria2c.com/"
	echo "google-chrome 浏览器已打开！"
else 
	firefox --verision
	if [ "${?}" -eq 0 ];then
		firefox "http://aria2c.com/"
		echo "firefox 浏览器已打开！"
	else
		x-www-browser "http://aria2c.com/"
	fi
fi


