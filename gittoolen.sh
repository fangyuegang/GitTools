#！/ban/bash
arr=()
arr_name=()
arr_ini_command=()
arr_build_command=()
curPath=$(dirname $(readlink -f "$0"))
 
ReadFile(){
	IFS=$'\n\n' 
	#echo awk '/<projectname>/,/<\/projectname>/ {print $0}' server.xml | awk -v FS="<projectname>" -v OFS=" " '{print $2}' | awk -v FS="<\/projectname>" -v OFS=" " '{print $1}'
	for ele_value in `cat $curPath/ProjectConfigEn.xml | awk -F '>' '{print $2}' | awk -F '<' '{print $1}'`
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
echo 1.The Git initialization
echo 2.Update the version in the current warehouse
echo 3.Code go to library
echo 4.The code to compile 
echo 5.Updates download specific warehouse
echo 6.The download version 
echo 7.The fallback code
echo 8.Reverse code to a specific version 
echo 9.The new Branch
echo 10.View the Git upload record 
echo 11.Code conflict handling
echo "If you have any questions or suggestions, please contact fangyuegang"
echo "mailbox 2251858097@qq.com"
read -p "Please enter your choice:" num
if 	 [ $num == 1 ];
	then
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
	elif [ $VersionSelect -eq $ini_select ];
		then echo "The version you currently select:"${arr_name[$VersionSelect]}
		eval ${arr_ini_command[$VersionSelect]}
	else
		echo "The input does not meet the criteria"
	fi
elif [ $num == 2 ];
	then echo "Update the version in the current warehouse"
	repo sync .
elif [ $num  == 3 ];
	then echo "Code go to library"
	git add .
	git commit
	echo 1.The startup code is uploaded to the server
	echo 2.Do not start code upload to server
	read -p "Please enter your choice:" UploadServer
	if [ $UploadServer == 1 ];
		then echo "The startup code is uploaded to the server"
		repo upload .
		echo 1.Start code compilation
		echo 2.Code compilation is not started
		read -p "Please enter your choice:" CodeCompilation
			if [ $CodeCompilation == 1 ];
				then echo "Start code compilation"
				read -p "Please enter your Branch name:" BranchName
				read -p "Please enter your changeID:" ChangName
				repo build -b $BranchName $ChangName
			elif [ $CodeCompilation == 2 ];
				then echo "Code compilation is not started"
			else 
				echo "The input does not meet the criteria"
			fi
	elif [ $UploadServer == 2 ];
		then echo "Do not start code upload to server"
	else
		echo "The input does not meet the criteria"
	fi
elif [ $num == 4 ];
	then echo "Executing compiled code"
	ReadFile
	for i in ${arr_name[@]}
	do 
		ini_select=$(($ini_select+1))
		echo $ini_select:$i
	done
	read -p "Please enter your choice:" VersionSelect
	echo $ini_select
	if [ $VersionSelect -lt $ini_select ];
		then echo "The version you currently select:"${arr_name[$VersionSelect]}
		eval ${arr_build_command[$VersionSelect]}
	elif [ $VersionSelect -eq $ini_select ];
		then echo "The version you currently select:"${arr_name[$VersionSelect]}
		eval ${arr_build_command[$VersionSelect]}
	else
		echo "The input does not meet the criteria"
	fi

elif [ $num == 5 ];
	then echo "Updates download specific warehouse"
	read -p "Please enter your updated warehouse name:" StoreHouse
	repo sync -c $StoreHouse
elif [ $num == 6 ];
	then echo "The download version"
	repo sync -j16 -c --no-tags
elif [ $num == 7 ];
	then echo "The fallback code"
	git status
	echo 1.No display, please enter 1
	echo 2.Display green, please enter 2
	echo 3.Display red, please enter 3
	read -p "Please enter your choice:" RollbackSelection
		if [ $RollbackSelection == 1];
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
		else
		echo "The input does not meet the criteria"
		fi
	echo "If the rollback is not successful and the display file is red, it is added and can be deleted directly"
elif [ $num == 8 ];
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
	echo 1.Pull a single warehouse
	echo 2.Pull down all the code
	read -p "Please enter your choice:" GetCodeSelect
	if [ $GetCodeSelect == 1 ];
		then read -p "Please enter your warehouse name:" WarehouseName
		repo sync -j16 -c $WarehouseName
	elif [ $GetCodeSelect == 2 ];
		then repo sync -j16 -c --no-tags
	else
	echo "The input does not meet the criteria"
	fi
elif [ $num == 9 ];
	then read -p "Please enter your Branch name:" FileName
	repo start $FileName --all
elif [ $num == 10 ];
	then git log
elif [ $num == 11 ];
	then echo "See the conflict:"
	git diff
else
	echo "The input does not meet the criteria"
fi
