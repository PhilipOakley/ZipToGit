#!/bin/sh
# start our new repo here
homepwd="$PWD"
# . "$homepwd/UnzipGitValues.sh" # set up the defaults from homepwd
. "UnzipGitValues.sh" # set up the defaults from path
mkdir "$gitdir"
cd "$gitdir"
UserName="Philip Oakley"
UserEmail="philipoakley@iee.org"
git init
git config user.name "$UserName"
git config user.email "$UserEmail"
git config autocrlf true

# get the default files 
for file in $BaseFiles     # Splits the variable in parts at whitespace.
do
  cp -p "$homepwd/$file" "$file"
done
# cp -p "$homepwd/.gitignore" . # get our repo files to here .
# cp -p "$homepwd/.gitattributes" .
# cp -p "$homepwd/ReadMe.txt" .
# cp -p "$homepwd/ReadMe/*" . # and anything else
echo "--- adding"
git add .
# set a startdate
TimeDate="$StartTimeDate" # example 2011-12-30T15:46:09+0000
echo "Initialise at $TimeDate"
export GIT_COMMITTER_DATE="$TimeDate"
export GIT_COMMITTER_EMAIL="$UserEmail"
export GIT_COMMITTER_NAME="$UserName"
git commit -a -m "Initial commit of gitignore, gitattributes & ReadMe" --author="$pjo"  --date="$TimeDate" --allow-empty
git tag "v0.0.0-InitialCommit"
export GIT_COMMITTER_DATE=
export GIT_COMMITTER_EMAIL=
export GIT_COMMITTER_NAME=
cd "$homepwd" # back to the starting directory

# use line below to get your "starter for 10" command list.

#   ls -tr1  *.zip | sed -e "s/^/UnzipGitCommit.sh \"/" | sed -e "s/$/\"/" > UnZipList.txt
# or, adding a destination directory,
#   ls -tr1  *.zip | sed -e "s/^/UnzipGitCommit.sh \"/" | sed -e "s/$/\"  \"Proj_code\"/" > UnZipList.txt


# You can now adjust the list order, add branch & merge points etc until it builds the way you want it.