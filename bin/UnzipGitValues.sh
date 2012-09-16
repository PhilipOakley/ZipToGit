#!/bin/sh
# start our new repo here
export gitdir="/d/Proj_git" # where is the git dir/repo we are populating. 
export tempdir="/c/gitunziptmp"  # where will we put the temporary unzips
#  author="Sample Name <sample.name@somewhere.com>" # example
export Him="Him <him@example.com>"
export pjo="Philip OAKLEY <philipoakley@iee.org>"
export Her="Her <her@example.com>"
#set author="$<author>" prior to the main script
# e.g. #export author="$pjo"
export src_dir="/f/Proj Backups"
export BaseFiles=".gitignore .gitattributes ReadMe.txt " # need these every commit - have relevant local copies

# set a startdate
export StartTimeDate="2009-06-10T12:00:00+0000" # example 2011-12-30T15:46:09+0000
