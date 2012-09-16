#!/bin/sh
#----------------------
# Support conversion of zip files from a simple VCS (Version Control System) process.
# This process is particularly easy on Windows,
# whereby the Top Level Directory's (TLD) name is used as the version number,
# the common code is one level down, and the TLD is zipped as the CVS snapshot,
# and the TLD name is then updated before the next zip.
# The zips ate kept as the local VCS!
# (Major releases may well be stored in some super corporate system at some expense ;-)
#
# The zip snapshots are ideal for conversion to Git.

# this scrip 'UXGC0' presumes there is no special TLD so commits everything 'as-is'

homepwd="$PWD"
. "$homepwd/UnzipGitValues.sh" # set up the defaults
rm -rf "$tempdir" # remove recursively forcefully
# echo "$tempdir"
# Usage: $dirContaingZip> UZGC0 <YourZip> 
#  don't forget to make this script executable (chmod u+rx scriptname)
echo "Convert Zip $1 to Git and commit it"
unzipfile="$1" # path must be relative to $pwd

# default variables needed (from UnziGitValues.sh)
#  girdir="/c/Documents and Settings/Philip/My Documents/GitAliasTest"
#  tempdir="/c/gitunziptmp"  # where will we put the temporary unzip
#  author="Sample Name <sample.name@somewhere.com>" # example

unzip -o -qq "$unzipfile" -d "$tempdir"
# # find the name of the TLD the user used, and get below it.
# #numsubdirs="$(ls -d $tempdir/*/ | wc -l)"
# numsubdirs="$(ls -ld $tempdir | cut -c11-15)" # allow for . and .. 
# # echo "$tempdir sub-dirs : $numsubdirs"
# # check there is only one subdir? 
# if test $numsubdirs -ge 4 
# then
  # echo "too many sub-dirs : $numsubdirs"
  # exit
# fi
# if test $numsubdirs -eq 3 
# then
 # tempsubdir="$(ls -d $tempdir/*/ | head -1 | sed "s|\\$||" )" # Only list the directories in the current directory.
 # echo "OneSubDir tempsubdir :  $tempsubdir"
# else
 # tempsubdir="$tempdir"
 # echo "NoSubDir tempsubdir :  $tempsubdir"
# fi
tempsubdir="$tempdir"

# echo "tempsubdir :  $tempsubdir"
# copy across the independent 'need to keep' files - could be a script.
# get the default files
for file in $BaseFiles     # Splits the variable in parts at whitespace.
do
  cp -p --target-directory="$tempsubdir" "$gitdir/$file"
done

# ls $tempsubdir
# exit
# these need to be already in the repo otherwise their time stamp may interfere
# cp -p "$girdir/.gitignore" "$tempsubdir" # get our repo files.
# cp -p "$girdir/.gitattributes" "$tempsubdir"
# cp -p "$girdir/ReadMe.txt" "$tempsubdir"
# cp -p "$girdir/ReadMe/*" "$tempsubdir" # and anything else

# echo "--work-tree=$tempsubdir --git-dir=$gitdir/.git"
# GIT_WORK_TREE="$tempsubdir" # could be set for the duration
# GIT_DIR="$gitdir/.git" 
echo git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status

git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" add --all . # add everything new and changed
# list the new & changed files, and then use 'ls' to sort them in date order
# and remember the most recent file.
# msysgit doesn't include 'stat()', so we couldn't use that.
echo "---- status"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  status -u --porcelain
echo "------- diff"  
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  diff  --no-renames --name-status --diff-filter=ACMRTB --src-prefix="$tempsubdir"\
   --cached  HEAD 
echo "--------- pipe it"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status -u --porcelain\
 | sed -e "s|^...|$tempsubdir\/|"
echo "--------- pipe it, ls sort it"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status -u --porcelain\
 | sed -e "s|^...|$tempsubdir\/|"\
 | xargs ls -t -1

echo "------try  LastFile="

LastFile=$(\
 git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
   status -u --porcelain\
 | sed -e "s|^...|$tempsubdir\/|"\
 | xargs ls -t -1 \
 | head -1)
TimeDate=$(date --reference="$LastFile" --iso-8601=seconds)

echo "Latest file is $LastFile modified at $TimeDate"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  diff-index --no-renames --name-status --diff-filter=AM HEAD
  
echo " now Commit it !"
GIT_COMMITTER_DATE="$TimeDate"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  commit -a -m "$unzipfile" --allow-empty --author="$author"  --date="$TimeDate"
GIT_COMMITTER_DATE= # reset to default of 'now'
# git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status
# tidy up
exit # leave the directories in place till all coding sorted [delete at start]
rm -rf "$tempdir" # remove recursively forcefully
# ls -1 "$tempdir"
