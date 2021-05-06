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
	echo 1.Download the cell code
	echo 2.Download the full code
	echo 3.exit	
	read -p "Please enter your choice:" download_select
	if [ $download_select == 1 ];
		then
		echo "Start downloading the cell code"
		read -p "Please enter the name of the warehouse you want to download:" warehouse_select
		repo sync -j16 -c warehouse_select
	elif [ $download_select  == 2 ];
		then 
		echo "Start downloading the entire code"
		repo sync -j16 -c --no-tags
	else
		echo "exit"
	fi
}

InitProject(){
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "Please enter your choice:" VersionSelect
	#echo $ini_select
	if [ $VersionSelect -lt $ini_select ];
		then echo "The version you currently select:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
		DownloadCode
	elif [ $VersionSelect -eq $ini_select ];
		then echo "The version you currently select:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
		DownloadCode
	else
		echo "The input does not meet the criteria,exit"
	fi
}

UpdateProject(){
	echo 1.Update the current warehouse code in the warehouse
	echo 2.Do not update the single warehouse code inside the warehouse
	echo 3.Update all the code
	echo 4.exit
	read -p "Please enter your choice:" update_select
	if	[ $update_select == 1 ];
		then echo "Updating the current warehouse code"
		repo sync .
	elif	[ $update_select == 2 ];
		then echo "The specific warehouse is being updated"
		read -p "Please enter your updated warehouse name:" StoreHouse
		repo sync -c $StoreHouse
	elif	[ $update_select == 3 ];
		then echo "Updating all the code"
		repo sync -j16 -c --no-tags
	else
		echo "exit"
	fi
}

PushLibrary(){
	git status
	echo 1.Add a single file to your local repository
	echo 2.Add all files to your local repository
	echo 3.Exit
	read -p "Please enter your choice:" add_local_warehouse
	if [ $add_local_warehouse == 1 ];
		then 
		add_select=1
		while [ $add_select -ne 2 ]
		do
			read -p "Please enter the filename you want to add:" add_file_name
			git add $add_file_name
			read -p "To continue, enter 2 to exit:" add_select
		done
	elif [ $add_local_warehouse == 2 ];
		then 
		git add .
	fi
	echo 1.Submit the local bin code to the remote bin
	echo 2.Exit
	read -p "Please enter your choice:" add_remote_warehouse
	if [ $add_remote_warehouse == 1 ];
		then 
		git commit
	else
		echo "Exit"
	fi
	echo 1.The startup code is uploaded to the server
	echo 2.Do not start code upload to server
	echo 3.Exit
	read -p "Please enter your choice:" UploadServer
	if [ $UploadServer == 1 ];
		then echo "The startup code is uploaded to the server"
		repo upload .
		echo 1.Start code compilation
		echo 2.Code compilation is not started
		echo 3.Exit
		read -p "Please enter your choice:" CodeCompilation
			if [ $CodeCompilation == 1 ];
				then echo "Start code compilation"
				read -p "Please enter your Branch name:" BranchName
				read -p "Please enter your changeID:" ChangName
				repo build -b $BranchName $ChangName
			elif [ $CodeCompilation == 2 ];
				then echo "Code compilation is not started"
			else 
				echo "Exit"
			fi
	elif [ $UploadServer == 2 ];
		then echo "Do not start code upload to server"
	else
		echo "Exit"
	fi

}
echo 1.Git initialization
echo 2.The code to library 
echo 3.The code to compile 
echo 4.Update the code
echo 5.The fallback code
echo 6.Reverse code to a specific version 
echo 7.The new Branch
echo 8.View the Git upload record 
echo 9.Code conflict handling
echo 10.Exit
echo "If you have any questions or suggestions, please contactfangyuegang"
echo "Mailbox 2251858097@qq.com"
read -p "Please enter your choice:" num
if	[ $num == 1 ];
	then
	current_path=`pwd`
	cd ~
	home_path=`pwd`
	cd $current_path
	if [ "$current_path" == "$home_path" ];
		then 
		echo "It is detected that you are currently operating under the home directory. It is suggested to create a folder"
		read -p "Please enter the name of the folder you created:" ini_file_name
		mkdir $ini_file_name
		cd $current_path/$ini_file_name
		InitProject
	else 
		InitProject
	fi
elif [ $num  == 2 ];
	then echo "The library code, please make sure the current code is up to date"
	echo 1.Is the latest code, continue to library
	echo 2.Not up to date code, exit
	read -p "Please enter your choice:" laset_code
	if	[ $laset_code == 1 ];
		then 
		current_branch_name=`git rev-parse --abbrev-ref HEAD`
		empty_branch_name=" "
		echo $current_branch_name
		if [ "$current_branch_name" == "$empty_branch_name" ]; 
			then echo "No Branch is currently detected"
			echo $empty_branch_name
			read -p "Please enter the name of the Branch you created:" new_branch_name
			repo start $new_branch_name --all
		else 
			echo "A current exists detected"$current_branch_name"branch"	
		fi
		PushLibrary
	else
		echo "exit"
	fi
elif [ $num == 3 ];
	then echo "Executing compiled code"
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "Please enter your choice:" VersionSelect
	if [ $VersionSelect -lt $ini_select ];
		then 
		echo "The version you currently select:"${arr_name[$VersionSelect]}
		for ((i=0;i<20;i++))
		do 
			repo_path=`find . -maxdepth 1 -name '.repo'`
			if [ -n "$repo_path" ];
				then 
				break
			fi
			cd ../
		done
		echo 1.Select Compile Partial Mirror
		echo 2.Select to compile all images
		echo 3.Exit
		read -p "Please enter your choice:" build_select
		if [ $build_select==1 ];
			then 
			read -p "Please enter the name of the image you want to compile:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "exit"
		fi
	elif [ $VersionSelect -eq $ini_select ];
		then 
		echo "The version you currently select:"${arr_name[$VersionSelect]}
		echo 1.Select Compile Partial Mirror
		echo 2.Select to compile all images
		echo 3.Exit
		read -p "Please enter your choice:" build_select
		if [ $build_select==1 ];
			then 
			read -p "Please enter the name of the image you want to compile:" build_name
			eval ${arr_build_command[$VersionSelect]} $build_name
		elif [ $build_select==2 ];
			then 
			eval ${arr_build_command[$VersionSelect]}
		else
			echo "exit"
		fi
	else
		echo "exit"
	fi
elif [ $num == 4 ];
	then 
	UpdateProject
elif [ $num == 5 ];
	then echo "The fallback code"
	git status
	echo 1.No display, please enter 1
	echo 2.Display green, please enter 2
	echo 3.isplay red, please enter 3
	echo 4.It takes a long time to roll back all code that has been modified locally
	echo 5.Exit
	read -p "Please enter your choice:" RollbackSelection
		if [ $RollbackSelection == 1 ];
		then git reset --soft HEAD^
		git status
		read -p "Please enter the fallback code path:" FilePath
		git reset HEAD $FilePath
		git checkout $FilePath
		elif [ $RollbackSelection == 2 ];
		then git status
		read -p "Please enter the fallback code path:" FilePath
		git reset HEAD $FilePath
		git checkout $FilePath
		elif [ $RollbackSelection == 3 ];
			then git status
			read -p "Please enter the fallback code path:" FilePath
			git checkout $FilePath
		elif [ $RollbackSelection == 4 ];
			then
			repo forall -c git reset --hard HEAD
		else
		echo "exit"
		fi
	echo "If the rollback is not successful and the display file is red, it is added and can be deleted directly"
elif [ $num == 6 ];
	then echo "Reverse code to a specific version"
	read -p "Please enter the location of your manifest. XML file:" FilePath
	echo $FilePath
	read -p "Please enter the path to.repo:" NewFilePath
	echo $NewFilePath/.repo/manifests/
	sudo chmod -R 750 $NewFilePath/.repo/manifests/
	cp $FilePath $NewFilePath/.repo/manifests/
	echo "This is where you replace the manifest. XML path"$NewFilePath"/.repo/manifests/"
	cd $NewFilePath/.repo/manifests/
	git add .
	git commit
	cd $NewFilePath
	repo init -m manifest.xml
	echo 1.Pull when warehouse
	echo 2.Pull down all the code
	echo 3.Exit
	read -p "Please enter your choice:" GetCodeSelect
	if [ $GetCodeSelect == 1 ];
		then read -p "Please enter your warehouse name:" WarehouseName
		repo sync -j16 -c $WarehouseName
	elif [ $GetCodeSelect == 2 ];
		then repo sync -j16 -c --no-tags
	else
	echo "exit"
	fi
elif [ $num == 7 ];
	then read -p "Please enter your Branch name:" FileName
	repo start $FileName --all
elif [ $num == 8 ];
	then git log
elif [ $num == 9 ];
	then echo "See the conflict:"
	git diff
else
	echo "exit"
fi
