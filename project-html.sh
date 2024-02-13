#!/bin/zsh

dir="./new_project"
rm_readme=0
force=0
rm_git=0
cpflags=""
pflags=""

if [[ $# -gt 0 ]]; then
	for arg in $@; do
		if [[ $arg[1] == "-" ]]; then
			if [[ $arg =~ "f" ]]; then
				pflags=($pflags "f")
				force=1
			fi
			if [[ $arg =~ "r" ]]; then
				pflags=($pflags "r")
				rm_readme=1
			fi
			if [[ $arg =~ "g" ]]; then
				rm_git=1
			fi
			if [[ $arg =~ "t" ]]; then
				cpflags=($cpflags "t")
			fi
			if [[ $arg =~ "b" ]]; then
				cpflags=($cpflags "b")
			fi
		else
			dir=$arg
		fi
	done
fi

echo "Creating a new HTML project."
scripts_dir=$0:A:h
$scripts_dir/project.sh -g$pflags $dir

echo "Adding files..."
cp $scripts_dir/res/html-$cpflags/* $dir

if [[ rm_git -eq 0 ]]; then
	echo "> Creating .gitignore"
	touch .gitignore

	echo "> Initializing git"
	git init
	git add .
	git commit -m "Initial comit"
fi
