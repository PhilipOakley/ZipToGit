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

# this scrip 'UnZipGitCommit0.sh' presumes there is no special TLD so commits everything 'as-is'

homepwd="$PWD"
# . "$homepwd/UnzipGitValues.sh" # set up the defaults from homepwd
. "UnzipGitValues.sh" # set up the defaults from path
rm -rf "$tempdir" # remove recursively forcefully

# Usage: $dirContaingZip> UnZipGitCommit0.sh <YourZip> [<sub-directory>]
#  don't forget to make this script executable (chmod u+rx scriptname)
echo ""
echo "Convert Zip (0): $1 to Git and commit it, placed sub-directory $2"
unzipfile="$1" # path must be relative to $pwd


# default variables needed (from UnziGitValues.sh)
#  girdir="/c/Documents and Settings/Philip/My Documents/GitAliasTest"
#  tempdir="/c/gitunziptmp"  # where will we put the temporary unzip
#  author="Sample Name <sample.name@somewhere.com>" # example
mkdir -p "$tempdir/$2" # should work if $2 is empty/missing.
unzip -o -qq "$unzipfile" -d "$tempdir/$2"  

tempsubdir="$tempdir/"

# get the default files
for file in $BaseFiles     # Splits the variable in parts at whitespace.
do
  cp -p --target-directory="$tempsubdir" "$gitdir/$file"
done

# these need to be already in the repo index otherwise, as new files, their time stamp may interfere
# cp -p "$girdir/.gitignore" "$tempsubdir" # get our repo files.
# cp -p "$girdir/.gitattributes" "$tempsubdir"
# cp -p "$girdir/ReadMe.txt" "$tempsubdir"
# cp -p "$girdir/ReadMe/*" "$tempsubdir" # and anything else

# GIT_WORK_TREE="$tempsubdir" # could be set for the duration
# GIT_DIR="$gitdir/.git" 

git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" add --all . # add everything new and changed
# list the new & changed files, and then use 'ls' to sort them in date order
# and remember the (date of) most recent file.
# msysgit doesn't include 'stat()', so we couldn't use that.
LastFile=$(\
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  diff  --no-renames --name-status --diff-filter=ACMRTB --src-prefix="$tempsubdir"\
   --cached  HEAD \
 | sed -e "s|^..|$tempsubdir|"\
 | sed -e 's|^|\"|' | sed -e 's|$|\"|'\
 | xargs ls -t -1\
 | head -1)
 
TimeDate=$(date --reference="$LastFile" --iso-8601=seconds)
echo "Latest file is $LastFile modified at $TimeDate"

echo " now Commit the zip ! Author = $author"
export GIT_COMMITTER_DATE="$TimeDate"
git --work-tree="$tempsubdir" --git-dir="$gitdir/.git"\
  commit -a -m "$unzipfile" --allow-empty --author="$author"  --date="$TimeDate"
export GIT_COMMITTER_DATE= # reset to default of 'now'

# git --work-tree="$tempsubdir" --git-dir="$gitdir/.git" status
