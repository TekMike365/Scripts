#!/bin/zsh

dir="./new_project"
rm_readme=0
force=0
rm_git=0

if [[ $# -gt 0 ]]; then
	for arg in $@; do
		if [[ $arg[1] == "-" ]]; then
			if [[ $arg =~ "h" ]]; then
				echo "
Project. The project creation helper.
Project creates and initiates a git repository. Other than that,
it doesn't really do shit. It is used in every other Project
script.

Usage: project.sh [arguments](*) [path](**/*3)
       
Arguments:
  -f	force, replaces the existing directory
  -r	remove README, doesn't create readme
  -g	git repository will not be initialized

*  You can string the arguments, ie. '-fr' is the same as '-f -r'.
   Position doesn't matter
** Path with a name of the folder, ie. /path/do/dir/project_name.
*3 Underscores will be replaced by spaces in README file.
"
				return
			fi
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
