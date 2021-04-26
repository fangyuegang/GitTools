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
echo 1.Git初始化
echo 2.在当前仓里面更新版本
echo 3.上库代码
echo 4.代码编译 
echo 5.更新下载特定的仓
echo 6.下载版本 
echo 7.回退代码
echo 8.将代码回退到特定版本 
echo 9.新建Branch
echo 10.查看Git上传记录 
echo 11.代码冲突处理
echo "如果有使用问题或者建议,请联系fangyuegang"
echo "邮箱 2251858097@qq.com"
read -p "请输入您的选择:" num
if 	 [ $num == 1 ];
	then
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
	elif [ $VersionSelect -eq $ini_select ];
		then echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
	else
		echo "输入不满足条件"
	fi
elif [ $num == 2 ];
	then echo "在当前仓里面更新版本"
	repo sync .
elif [ $num  == 3 ];
	then echo "上库代码"
	git add .
	git commit
	echo 1.启动代码上传到服务器
	echo 2.不启动代码上传到服务器
	read -p "请输入您的选择:" UploadServer
	if [ $UploadServer == 1 ];
		then echo "启动代码上传到服务器"
		repo upload .
		echo 1.启动代码编译
		echo 2.不启动代码编译
		read -p "请输入您的选择:" CodeCompilation
			if [ $CodeCompilation == 1 ];
				then echo "启动代码编译"
				read -p "请输入你的Branch名称:" BranchName
				read -p "请输入你的ChangeId:" ChangName
				repo build -b $BranchName $ChangName
			elif [ $CodeCompilation == 2 ];
				then echo "不启动代码编译"
			else 
				echo "输入不满足条件"
			fi
	elif [ $UploadServer == 2 ];
		then echo "不启动代码上传到服务器"
	else
		echo "输入不满足条件"
	fi
elif [ $num == 4 ];
	then echo "执行编译代码"
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "请输入您的选择:" VersionSelect
	echo $ini_select
	if [ $VersionSelect -lt $ini_select ];
		then 
		echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		echo 1.选择编译部分镜像
		echo 2.选择编译所有镜像
		read -p "请输入你的选择:" build_select
		if [ $build_select==1 ];
			then 
			read -p "请输入你需要编译的镜像名称:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "输入不满足条件"
		fi
	elif [ $VersionSelect -eq $ini_select ];
		then 
		echo "你当前选择的版本:"${arr_name[$VersionSelect]}
		echo 1.选择编译部分镜像
		echo 2.选择编译所有镜像
		read -p "请输入你的选择:" build_select
		if [ $build_select==1 ];
			then 
			read -p "请输入你需要编译的镜像名称:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "输入不满足条件"
		fi
	else
		echo "输入不满足条件"
	fi
elif [ $num == 5 ];
	then echo "更新下载特定的仓"
	read -p "请输入您更新的仓名:" StoreHouse
	repo sync -c $StoreHouse
elif [ $num == 6 ];
	then echo "下载版本"
	repo sync -j16 -c --no-tags
elif [ $num == 7 ];
	then echo "回退代码"
	git status
	echo 1.无显示，请输入1
	echo 2.显示绿色，请输入2
	echo 3.显示红色，请输入3
	read -p "请输入您的选择:" RollbackSelection
		if [ $RollbackSelection == 1];
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
		else
		echo "输入不满足条件"
		fi
	echo "如果回退未成功且显示文件为红色，则为新增，直接删除即可"
elif [ $num == 8 ];
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
	read -p "请输入你的选择:" GetCodeSelect
	if [ $GetCodeSelect == 1 ];
		then read -p "请输入你的仓名:" WarehouseName
		repo sync -j16 -c $WarehouseName
	elif [ $GetCodeSelect == 2 ];
		then repo sync -j16 -c --no-tags
	else
	echo "输入不满足条件"
	fi
elif [ $num == 9 ];
	then read -p "请输入你的Branch名称:" FileName
	repo start $FileName --all
elif [ $num == 10 ];
	then git log
elif [ $num == 11 ];
	then echo "查看冲突:"
	git diff
else
	echo "输入不满足条件"
fi
