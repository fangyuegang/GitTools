#！/ban/bash
arr=()
arr_name=()
arr_ini_command=()
arr_build_command=()
curPath=$(dirname $(readlink -f "$0"))
 
ReadFile(){
	IFS=$'\n\n' 
	#echo awk '/<projectname>/,/<\/projectname>/ {print $0}' server.xml | awk -v FS="<projectname>" -v OFS=" " '{print $2}' | awk -v FS="<\/projectname>" -v OFS=" " '{print $1}'
	for ele_value in `cat $curPath/ProjectConfig.xml | awk -F '>' '{print $2}' | awk -F '<' '{print $1}'`
	do
		a=$(($a+1))
		arr[$a]=$ele_value
	done
	
	for i in ${!arr[@]}
	do 
		j=$(( $i % 3 ))
		if [ $j == 1 ];
			then 
			name_key=$(($name_key+1))
			arr_name[$name_key]=${arr[$i]}
		elif [ $j == 2 ];
			then 
			name_key1=$(($name_key1+1))
			arr_ini_command[$name_key1]=${arr[$i]}
			#echo $name_key1 ${arr_ini_command[$name_key]}
		elif [ $j == 0 ];
			then 
			name_key2=$(($name_key2+1))
			arr_build_command[$name_key2]=${arr[$i]}
		fi
	done
}

DownloadCode(){
	echo 1.下载单仓代码
	echo 2.下载全部代码
	echo 3.退出	
	read -p "请输入您的选择:" download_select
	if [ $download_select == 1 ];
		then
		echo "开始下载单仓代码"
		read -p "请输入您想要下载的仓名:" warehouse_select
		repo sync -j16 -c warehouse_select
	elif [ $download_select  == 2 ];
		then 
		echo "开始下载全部代码"
		repo sync -j16 -c --no-tags
	else
		echo "退出"
	fi
}

InitProject(){
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "请输入您的选择:" VersionSelect
	#echo $ini_select
	if [ $VersionSelect -lt $ini_select ];
		then echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
		DownloadCode
	elif [ $VersionSelect -eq $ini_select ];
		then echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
		DownloadCode
	else
		echo "输入不满足条件,退出"
	fi
}

UpdateProject(){
	echo 1.在仓里面更新当前仓代码
	echo 2.不在仓里面更新单仓代码
	echo 3.更新全部代码
	echo 4.退出
	read -p "请输入您的选择:" update_select
	if	[ $update_select == 1 ];
		then echo "正在更新当前仓代码"
		repo sync .
	elif	[ $update_select == 2 ];
		then echo "正在更新特定的仓"
		read -p "请输入您更新的仓名:" StoreHouse
		repo sync -c $StoreHouse
	elif	[ $update_select == 3 ];
		then echo "正在更新全部代码"
		repo sync -j16 -c --no-tags
	else
		echo "退出"
	fi
}

PushLibrary(){
	git status
	echo 1.添加单个文件到自己本地仓
	echo 2.添加全部文件到自己本地仓
	echo 3.退出
	read -p "请输入您的选择:" add_local_warehouse
	if [ $add_local_warehouse == 1 ];
		then 
		add_select=1
		while [ $add_select -ne 2 ]
		do
			read -p "请输入你想添加的文件名:" add_file_name
			git add $add_file_name
			read -p "是否继续添加继续,退出请输入2:" add_select
		done
	elif [ $add_local_warehouse == 2 ];
		then 
		git add .
	fi
	echo 1.将本地仓代码提交到远端仓
	echo 2.退出
	read -p "请输入您的选择:" add_remote_warehouse
	if [ $add_remote_warehouse == 1 ];
		then 
		git commit
	else
		echo "退出"
	fi
	echo 1.启动代码上传到服务器
	echo 2.不启动代码上传到服务器
	echo 3.退出
	read -p "请输入您的选择:" UploadServer
	if [ $UploadServer == 1 ];
		then echo "启动代码上传到服务器"
		repo upload .
		echo 1.启动代码编译
		echo 2.不启动代码编译
		echo 3.退出
		read -p "请输入您的选择:" CodeCompilation
			if [ $CodeCompilation == 1 ];
				then echo "启动代码编译"
				read -p "请输入你的Branch名称:" BranchName
				read -p "请输入你的ChangeId:" ChangName
				repo build -b $BranchName $ChangName
			elif [ $CodeCompilation == 2 ];
				then echo "不启动代码编译"
			else 
				echo "退出"
			fi
	elif [ $UploadServer == 2 ];
		then echo "不启动代码上传到服务器"
	else
		echo "退出"
	fi

}
echo 1.Git初始化
echo 2.上库代码
echo 3.代码编译 
echo 4.更新代码
echo 5.回退代码
echo 6.将代码回退到特定版本 
echo 7.新建Branch
echo 8.查看Git上传记录 
echo 9.代码冲突处理
echo 10.退出
echo "如果有使用问题或者建议,请联系fangyuegang"
echo "邮箱 2251858097@qq.com"
read -p "请输入您的选择:" num
if	[ $num == 1 ];
	then
	current_path=`pwd`
	cd ~
	home_path=`pwd`
	cd $current_path
	if [ "$current_path" == "$home_path" ];
		then 
		echo "检测到你当前操作在家目录下面,建议创建文件夹"
		read -p "请输入你创建文件夹名:" ini_file_name
		mkdir $ini_file_name
		cd $current_path/$ini_file_name
		InitProject
	else 
		InitProject
	fi
elif [ $num  == 2 ];
	then echo "上库代码,请确保当前是最新代码"
	echo 1.已是最新代码，继续上库
	echo 2.非最新代码，退出
	read -p "请输入您的选择:" laset_code
	if	[ $laset_code == 1 ];
		then 
		current_branch_name=`git rev-parse --abbrev-ref HEAD`
		empty_branch_name=" "
		echo $current_branch_name
		if [ "$current_branch_name" == "$empty_branch_name" ]; 
			then echo "检测到当前没有Branch"
			echo $empty_branch_name
			read -p "请输入你创建Branch名称:" new_branch_name
			repo start $new_branch_name --all
		else 
			echo "检测到当前已经存在"$current_branch_name"分支"	
		fi
		PushLibrary
	else
		echo "退出"
	fi
elif [ $num == 3 ];
	then echo "执行编译代码"
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "请输入您的选择:" VersionSelect
	if [ $VersionSelect -lt $ini_select ];
		then 
		echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		for ((i=0;i<20;i++))
		do 
			repo_path=`find . -maxdepth 1 -name '.repo'`
			if [ -n "$repo_path" ];
				then 
				break
			fi
			cd ../
		done
		echo 1.选择编译部分镜像
		echo 2.选择编译所有镜像
		echo 3.退出
		read -p "请输入你的选择:" build_select
		if [ $build_select==1 ];
			then 
			read -p "请输入你需要编译的镜像名称:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "退出"
		fi
	elif [ $VersionSelect -eq $ini_select ];
		then 
		echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		for ((i=0;i<20;i++))
		do 
			repo_path=`find . -maxdepth 1 -name '.repo'`
			if [ -n "$repo_path" ];
				then 
				break
			fi
			cd ../
		done
		echo 1.选择编译部分镜像
		echo 2.选择编译所有镜像
		echo 3.退出
		read -p "请输入你的选择:" build_select
		if [ $build_select==1 ];
			then 
			read -p "请输入你需要编译的镜像名称:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "退出"
		fi
	else
		echo "退出"
	fi
elif [ $num == 4 ];
	then 
	UpdateProject
elif [ $num == 5 ];
	then echo "回退代码"
	git status
	echo 1.无显示，请输入1
	echo 2.显示绿色，请输入2
	echo 3.显示红色，请输入3
	echo 4.回退本地修改的所有代码,此过程较长
	echo 5.退出
	read -p "请输入您的选择:" RollbackSelection
		if [ $RollbackSelection == 1 ];
			then git reset --soft HEAD^
			git status
			read -p "请输入回退代码路径:" FilePath
			git reset HEAD $FilePath
			git checkout $FilePath
		elif [ $RollbackSelection == 2 ];
			then git status
			read -p "请输入回退代码路径:" FilePath
			git reset HEAD $FilePath
			git checkout $FilePath
		elif [ $RollbackSelection == 3 ];
			then git status
			read -p "请输入回退代码路径:" FilePath
			git checkout $FilePath
		elif [ $RollbackSelection == 4 ];
			then
			repo forall -c git reset --hard HEAD
		else
			echo "退出"
		fi
	echo "如果回退未成功且显示文件为红色，则为新增，直接删除即可"
elif [ $num == 6 ];
	then echo "将代码回退到特定版本"
	read -p "请输入你存放manifest.xml文件路径:" FilePath
	echo $FilePath
	read -p "请输入.repo的路径:" NewFilePath
	echo $NewFilePath/.repo/manifests/
	sudo chmod -R 750 $NewFilePath/.repo/manifests/
	cp $FilePath $NewFilePath/.repo/manifests/
	echo "这是你替换manifest.xml路径"$NewFilePath"/.repo/manifests/"
	cd $NewFilePath/.repo/manifests/
	git add .
	git commit
	cd $NewFilePath
	repo init -m manifest.xml
	echo 1.拉取当仓
	echo 2.拉取全部代码
	echo 3.退出
	read -p "请输入你的选择:" GetCodeSelect
	if [ $GetCodeSelect == 1 ];
		then read -p "请输入你的仓名:" WarehouseName
		repo sync -j16 -c $WarehouseName
	elif [ $GetCodeSelect == 2 ];
		then repo sync -j16 -c --no-tags
	else
	echo "退出"
	fi
elif [ $num == 7 ];
	then read -p "请输入你的Branch名称:" FileName
	repo start $FileName --all
elif [ $num == 8 ];
	then git log
elif [ $num == 9 ];
	then echo "查看冲突:"
	git diff
else
	echo "退出"
fi
