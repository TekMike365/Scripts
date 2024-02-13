#!/bin/zsh

dir=""
cpflags=""
pflags=""
rm_git=0

if [[ $# -gt 0 ]]; then
	for arg in $@; do
		if [[ $arg[1] == "-" ]]; then
			if [[ $arg =~ "h" ]]; then
				echo "
Project-HTML. The project creation helper.
Creates a html template (index.html, style.css, script.html),
and initates a git repository in your directory of coise!

Usage: project-html.sh [arguments](*) [path](**/*3)
       
Arguments:
  -f	force, replaces the existing directory
  -r	remove README, doesn't create readme
  -g	git repository will not be initialized
  -t	creates template (index.thml, style.css, script.html)
	with tabs (spaces are default)
  -b	creates just index.html

*  You can string the arguments, ie. '-fr' is the same as '-f -r'.
   Position doesn't matter
** Path with a name of the folder, ie. /path/do/dir/project_name.
*3 Underscores will be replaced by spaces in README file.
"

				return
			fi
			if [[ $arg =~ "f" ]]; then
				pflags=($pflags"f")
			fi
			if [[ $arg =~ "r" ]]; then
				pflags=($pflags"r")
			fi
			if [[ $arg =~ "g" ]]; then
				rm_git=1
			fi
			if [[ $arg =~ "t" ]]; then
				cpflags=($cpflags"t")
			fi
			if [[ $arg =~ "b" ]]; then
				cpflags=($cpflags"b")
			fi
		else
			dir=$arg
		fi
	done
fi

if [[ $dir == "" ]]; then
	echo "Error: No directory was specified."
	return
fi

echo "Creating a new HTML project."
scripts_dir=$0:A:h
$scripts_dir/project.sh -g$pflags $dir

echo "Adding files..."
echo $cpflags
cp $scripts_dir/res/html$cpflags/* $dir

cd $dir

if [[ $rm_git -eq 0 ]]; then
	echo "> Creating .gitignore"
	touch .gitignore

	echo "> Initializing git"
	git init
	git add .
	git commit -m "Initial comit"
fi
