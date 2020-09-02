#! /bin/bash

#判断命令是否执行成功
function Judge_Order(){
	local status=${?}
	echo
	echo
	if [ ${#} -eq 2 ];then
		#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
		if [ ${status} -eq 0 ];then
			echo -e "[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[33m\"${1}\" ""execute success!\033[0m"
		else 
			echo -e "[\033[36m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[31m\"${1}\" ""execute fail!\033[0m"
			if [ "${2}" -eq 0 ];then
				exit 127
			fi
		fi
		
	else
		echo -e "\033[31mThe method \"Judge_Order()\" unction parameter input is incorrect, please re-enter!\033[0m"
	fi
	echo
	echo
}

#判断对应的目录是存在
function  Determine_SoftwareFold_Exist()
{
	echo
	echo
	if [ ${#} -eq 1 ];then
		if [ -d "${HOME}/Software" ];then
			echo -e "\033[36m${HOME}/Software already exist!\033[0m"
		else
			mkdir ${HOME}/Software
			echo -e "\033[36m${HOME}/Software create success!\033[0m"	
		fi
		if [ -d "${HOME}/Software/${1}" ];then
			echo -e "\033[36m${HOME}/Software/${1} already exist!\033[0m"
		else
			mkdir ${HOME}/Software/${1}
			echo -e "\033[36m${HOME}/Chrome/${1} create success!\033[0m"	
		fi
	else
		echo -e "\033[31mThe method \"Determine_SoftwareFold_Exist()\" unction parameter input is incorrect, please re-enter!\033[0m"
	fi
	Judge_Order "Determine_SoftwareFold_Exist()" 1
	echo
	echo
}
function Determine_Cdrtool_Exist()
{
	cd ${HOME}/Software/ISO	
	if [ ! -f "/opt/schily/bin/mkisofs" ];then
		wget https://nchc.dl.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a07.tar.gz
		Judge_Order "wget https://nchc.dl.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a07.tar.gz" 0
		tar -xzvf cdrtools-3.02a07.tar.gz
		cd cdrtools-3.02/
		sudo make && sudo make install
		Judge_Order "sudo make && sudo make install" 0
		cd ..
		sudo rm -rf cdrtools-3.02/
		sudo rm -rf cdrtools-3.02a07.tar.gz
	else
		echo -e "\033[36mcdrtools-3.02 already install!\033[0m"
	fi

}
function Seletct_File()
{
	j=0
	for file in $(ls *.sblive)
	do
	    	echo "${j}   ${file}"
		echo
	    	file_list[j]=${file}
	    	let "j+=1"
	done
	echo
	echo
	if [ "${#file_list[@]}" -le 1 ];then
		number=0	
	else
		read -p "Please input a number:" number
		while [[ "${number}" -ge ${#file_list[@]} ]]  || [[ ${number} =~ ^[1-9]\d*|0$ ]] 
		do
			read -p "Your input is error,please input again:" number 
		done
	fi
}
function main()
{
	cd /home
	Seletct_File
	FileName=${file_list[number]}
	if [ -f "${FileName}" ];then
		Determine_SoftwareFold_Exist "ISO"
		Determine_Cdrtool_Exist
		if [ ! -f "${FileName}" ];then 
			sudo mv /home/${FileName} ${FileName} 
		fi
		sudo mkdir sblive
		sudo tar -xvf ${FileName} -C sblive
		Judge_Order "sudo tar -xvf ${FileName} -C sblive" 0
		sudo mv sblive/syslinux/syslinux.cfg sblive/syslinux/isolinux.cfg
		Judge_Order "sudo mv sblive/syslinux/syslinux.cfg sblive/syslinux/isolinux.cfg" 0
		sudo mv sblive/syslinux sblive/isolinux
		Judge_Order "sudo mv sblive/syslinux sblive/isolinux" 0
		sudo /opt/schily/bin/mkisofs -iso-level 3 -r -V sblive -cache-inodes -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o ${HOME}/Software/ISO/$(date +%Y%m%d%H%M%S)_Ubuntu16.04.iso sblive
		Judge_Order "sudo /opt/schily/bin/mkisofs -iso-level 3 -r -V sblive -cache-inodes -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat -o ${HOME}/Software/ISO/$(date +%Y%m%d%H%M%S)_Ubuntu16.04.iso sblive" 0
		sudo rm -rf ${FileName}
		Judge_Order "sudo rm -rf ${FileName}" 0
		sudo rm -rf $(pwd)/sblive
		Judge_Order "sudo rm -rf $(pwd)/sblive" 0

	else
		echo -e "\033[36mNo .sblive file is existence!\033[0m"
	fi


}
main



