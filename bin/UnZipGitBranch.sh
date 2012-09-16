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

# this scrip 'UnZipGitBranch.sh' changes to the branch requested

homepwd="$PWD"
# . "$homepwd/UnzipGitValues.sh" # set up the defaults from homepwd
. "UnzipGitValues.sh" # set up the defaults from path

# default variables needed (from UnziGitValues.sh)
#  girdir="/c/Documents and Settings/Philip/My Documents/GitAliasTest"
#  tempdir="/c/gitunziptmp"  # where will we put the temporary unzip

# --work-tree="$tempdir" 
git --git-dir="$gitdir/.git" branch -b "$1"

