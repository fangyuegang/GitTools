arr=()
arr_name=()
arr_ini_command=()
arr_build_command=()
project_path=$(cd `dirname $0`; pwd)

ReadFile(){
	IFS=$'\n\n'
	for ele_value in `cat project_path/ProjectConfig.xml \awk -F '>' '{print $2}' \awk -F '<' '{print $1}'`
	do
		index=$(($index+1))
		arr[$index]=$ele_value
	done
	for i in ${!arr[@]}
	do
		j=$(($i%3))
		if [ $j==1 ];
			then 
			project_name=$(($project_name+1))
			arr_name[$project_name]=${arr[$i]}
		elif [ $j==2 ];
			then
			project_ini=$(($project_ini+1))
			arr_ini_command[$project_ini]=${arr[$i]}
		elif [ $j==0 ];
			then
			project_build=$(($project_build+1))
			arr_build_command[$project_build]=${arr[$i]}
		fi
	done
}
main(){
	echo 1.Git初始化
	echo 2.在当前仓里面下载更新
	echo 3.上库代码
	echo 4.代码编译
	echo 5.更新下载特定的仓
	echo 6.下载版本
	echo 7.回退代码
	echo 8.将代码回退到特定版本
	echo 9.新建Branch
	echo 10.查看Git上传记录
	echo 11.代码冲突处理
	
	read -p "请输入你的选择:" select_num
	if [ $select_num==1 ];
		then 
		ReadFile
		for i in ${arr_name[@]}
		do 
			ini_select=$((ini_select+1))
			echo $ini_select:$i
		done
		read -p "请输入你的选择:" version_select
		if [ $version_select -lt $ini_select ];
			then 
			echo "你当前选择的项目:"${arr_ini_command[$version_select]}
			eval ${arr_ini_command[$version_select]}
		elif [ $version_select -eq $ini_select ];
			then 
			echo "你当前选择的项目:"${arr_ini_command[$version_select]}
			eval ${arr_ini_command[$version_select]}
		else
			echo "输入不满足条件"
		fi
	elif [ $select_num==2 ];
		then echo "在当前仓里面下载更新"
		repo sync .
	elif [ $select_num==3 ];
		then echo "上库代码"
		git add .
		git commit
		echo 1.启动编译
		echo 2.不启动编译
		read -p "请输入你的选择:"code_compilation
		if [ $code_compilation==1 ];
			then echo "启动编译"
			read -p "请输入你的Branch:" branch_name
			read -p "请输入你的CommitId:" change_id
			repo build -b branch_name change_id
		elif [ $code_compilation==2 ];
			then echo "不启动编译"
		else
			echo "输入不满足条件"
		fi
	elif [ $select_num==4 ];
		then 
		ReadFile
		for i in ${arr_name[@]}
		do 
			ini_select=$((ini_select+1))
			echo $ini_select:$i
		done
		read -p "请输入你的选择:" version_select
		if [ $version_select -lt $ini_select ];
			then 
			echo "你当前选择的项目:"${arr_build_command[$version_select]}
			eval ${arr_build_command[$version_select]}
		elif [ $version_select -eq $ini_select ];
			then 
			echo "你当前选择的项目:"${arr_build_command[$version_select]}
			eval ${arr_build_command[$version_select]}
		else
			echo "输入不满足条件"
		fi
	elif [ $select_num==5 ];
		then 
		read -p "请输入你的下载的仓名:"code_name
		repo sync -c code_name
	elif [ $select_num==6 ];
		then
		repo sync -j16 -c --no-tags
	elif [ $select_num==7 ];	
		then 
		echo "回退代码"
		git status
		echo 1.无文件显示
		echo 2.文件显示绿色
		echo 3.文件显示红色
		read -p "请输入你的选择:" roll_back_select
		if [ $roll_back_select==1 ];
			then 
			git reset --soft HEAD^
			git status
			read -p "请输入回退文件路径" roll_back_file_path
			git reset HEAD $roll_back_file_path
			git checkout $roll_back_file_path
		elif [ $roll_back_select==2 ]; 
			then 
			git status
			read -p "请输入回退文件路径" roll_back_file_path
			git reset HEAD $roll_back_file_path
			git checkout $roll_back_file_path
		elif [ $roll_back_select==3 ]; 
			then 
			git status
			read -p "请输入回退文件路径" roll_back_file_path
			git checkout $roll_back_file_path
		else
			echo "输入不满足条件"
		fi 
	elif [ $select_num==8 ];
		then 
		read -p "请输入你存放manifest.xml文件路径:" mani_file_path
		echo $mani_file_path
		read -p "请输入.repo文件路径:" new_mani_file_path
		echo $new_mani_file_path/.repo/manifests/
		sudo chmod -R 750 $new_mani_file_path/.repo/manifests/
		cp $mani_file_path $new_mani_file_path $new_mani_file_path/.repo/manifests/
		cd $new_mani_file_path/.repo/manifests/
		git add .
		git commit 
		cd $new_mani_file_path
		repo init -m manifest.xml
		echo 1.拉单仓
		echo 2.拉取全部代码
		read -p "请输入你的选择:" mani_file_pull_select
		if [ $mani_file_pull_select==1 ];
			then 
			read -p "请输入拉取仓名:" mani_file_pull_name
			repo sync -c $mani_file_pull_name
		elif [ $mani_file_pull_select==2 ];
			then 
			repo sync -j16 -c --no-tags
		else
			echo "输入不满足条件"
		fi
	elif [ $select_num==9 ];
		then 
		read -p "请输入你想建立的Branch名称:" branch_name
		repo start $branch_name --all
	elif [ $select_num==10 ];
		then 
		git log
	elif [ $select_num==11 ];
		then 
		git diff
	fi
}

main
