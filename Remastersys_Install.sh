#! /bin/bash

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
			exit 127
		fi
	fi
	echo
	echo
}
function  Determine_SoftwareFold_Exist()
{
	cd ${HOME}
	if [ -d "$(pwd)/Software" ];then
		echo "-------$(pwd)/Software already exist"
	else
		mkdir $(pwd)/Software
		echo "-------$(pwd)/Software create success"	
	fi
	if [ -d "$(pwd)/Software/Remastersys" ];then
		echo "-------$(pwd)/Software/Remastersys already exist"
	else
		mkdir $(pwd)/Software/Remastersys
		echo "-------$(pwd)/Software/Remastersys create success"	
	fi
}
function Update_All()
{
	sudo apt-get upgrade -y
	Judge_Order "-------upgrade success" "-------upgrade fail" 1
	sudo apt-get update -y
	Judge_Order "-------update success" "-------update fail" 1
	sudo apt-get -f install -y
	Judge_Order "-------Repair damaged packages success" "-------Repair damaged packages fail" 1
	sudo apt-get autoremove -y
	Judge_Order "-------autoremove success" "-------autoremove fail" 1
	Judge_Order "-------Update_All run success" "-------Update_All run fail" 1
}
function Remastersys_Install()
{
	dpkg -l remastersys
	if [ ${?} -eq 0 ];then
		echo "Remastersys already install"
		exit 0
	fi

	#判断Software目录是否存在
	Determine_SoftwareFold_Exist
	cd $(pwd)/Software/Remastersys
	sudo cp ${HOME}/桌面/remastersys_3.0.4-2_all.deb remastersys_3.0.4-2_all.deb
:<<!
	count=$(ls *.deb | wc -w)
	if [ "${count}" -gt 0 ];then
		cd /home/${USER}
		rm -rf $(pwd)/Software/Remastersys
		mkdir $(pwd)/Software/Remastersys
		echo "-------$(pwd)/Software/Remastersys delete success"
		cd $(pwd)/Software/Remastersys		
	fi
	#更新软件
	#Update_All
	wget http://www.pcds.fi/downloads/applications/system/backup/remastersys/ubuntu/remastersys_3.0.4-2_all.deb
	Judge_Order "remastersys_3.0.4-2_all.deb download success" "remastersys_3.0.4-2_all.deb download fail" 0
!
	#remastersys_3.0.4-2_all.deb可由下载链接看出
	count=$(ls *.deb | wc -w)
	if [ ${count} -eq 1 ];then
		#sudo add-apt-repository ppa:mutse-young/remastersys -y
		Update_All
		sudo dpkg -i remastersys_3.0.4-2_all.deb
		Judge_Order "remastersys_3.0.4-2_all.deb install success" "remastersys_3.0.4-2_all.deb install fail" 1
		Update_All
		sudo dpkg -i remastersys_3.0.4-2_all.deb
		Judge_Order "remastersys_3.0.4-2_all.deb install success" "remastersys_3.0.4-2_all.deb install fail" 0
		sudo rm -rf remastersys_3.0.4-2_all.deb
	else 
		echo "The file remastersys_3.0.4-2_all.deb is not existence!"
		exit 127	
	fi
	
}
Remastersys_Install
