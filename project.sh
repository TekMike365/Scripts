#!/bin/zsh

dir="./new_project"
rm_readme=0
force=0
rm_git=0

if [[ $# -gt 0 ]]; then
	for arg in $@; do
		if [[ $arg[1] == "-" ]]; then
			if [[ $arg =~ "f" ]]; then
				force=1
			fi
			if [[ $arg =~ "r" ]]; then
				rm_readme=1
			fi
			if [[ $arg =~ "g" ]]; then
				rm_git=1
			fi
		else
			dir=$arg
		fi
	done
fi

if [[ -e $dir ]]; then
	if [[ $force -eq 1 ]]; then
		read accept\?"Directory $dir already exists. Do you want to continue? (y/N): "
		if [[ $accept != "y" && $accept != "Y" && $accept != "yes" && $accept != "Yes" ]]; then
			echo "Process aborted."
			return
		fi
		echo "Removing original dir."
		rm -fr $dir
	else
		echo "Directory $dir already exists. Aborting process."
		return
	fi
fi

name=$dir:t:r		# get the file name (:t) without extension (:r)
name=$name:gs/_/" "	# replace '_' with ' '

echo "Creating project '$name' in $dir ..."

mkdir -p $dir
cd $dir

[[ $rm_readme -eq 0 ]] && echo "> Creating README" && echo "#$name" > README.md

if [[ rm_git -eq 0 ]]; then
	echo "> Creating .gitignore"
	touch .gitignore

	echo "> Initializing git"
	git init
	git add .
	git commit -m "Initial comit"
fi
