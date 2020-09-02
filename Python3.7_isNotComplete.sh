#! /bin/bash
#参考网站：https://www.cnblogs.com/zhaochenguang/p/10796909.html
#判断命令是否执行成功
function Judge_Order(){
	local status=${?}
	echo
	echo
	#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
	if [ ${status} -eq 0 ];then
		echo "${1}"
	else 
		echo "${2}"
		if [ "${3}" -eq 0 ];then
			exit 1
		fi
	fi
	echo
	echo
}

function  Determine_SoftwareFold_Exist()
{
	cd /home/${USER}
	if [ -d "$(pwd)/Software" ];then
		echo "-------$(pwd)/Software already exist"
	else
		mkdir $(pwd)/Software
		echo "-------$(pwd)/Software create success"	
	fi
	if [ -d "$(pwd)/Software/Python3.7" ];then
		echo "-------$(pwd)/Software/Python3.7 already exist"
	else
		mkdir $(pwd)/Software/Python3.7
		echo "-------$(pwd)/Software/Python3.7 create success"	
	fi
}
function Virtual_environment(){


}
function Python_Install(){
	Determine_SoftwareFold_Exist
	Judge_Order "-------Determine_SoftwareFold_Exist method run success" "-------Determine_SoftwareFold_Exist method run fail" 0
	cd $(pwd)/Software/Python3.7
	count=$(ls *.tgz | wc -w)
	if [ "${count}" -gt 0 ];then
		rm -rf $(pwd)/Software/Python3.7
		mkdir $(pwd)/Software/Python3.7
		echo "-------$(pwd)/Software/Python3.7 recreate success"		
	fi
	sudo wget https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz
	exeName=$(ls *.run)
	Judge_Order "-------${exeName} download success" "-------${exeName} download fail" 0
	sudo tar -xvzf Python-3.7.1.tgz
	cd Python-3.7.1
	./configure --with-ssl --prefix=/usr/local/python3
	Judge_Order "-------./configure --with-ssl --prefix=/usr/local/python3 run success" "-------./configure --with-ssl --prefix=/usr/local/python3 download fail" 0
	sudo apt-get install libffi-dev -y	
	sudo make && sudo make install
	sudo rm -rf /usr/bin/python3
	sudo rm -rf /usr/bin/pip3
	sudo ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3
	sudo ln -s /usr/local/python3/bin/pip3.7 /usr/bin/pip3
	python3 -V
	Judge_Order "-------python3.7 install success" "-------python3.7 install fail" 
	#需要修改pip3文件
	##!/usr/local/python3/bin/python3.7

	# -*- coding: utf-8 -*-
	#import re
	#import sys

	#from pip._internal import __main__

	#if __name__ == '__main__':
	#    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
	 #   sys.exit(__main__._main())

}
