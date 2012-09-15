ZipToGit - Converting Zip snapshots to a Git repository

Philip Oakley <philipoakley@iee.org>, 2012.

It is easy to take Zip snapshots of a directory as a mechanism for progress recording and version control. 

In Windows, one right clicks the directory, selects "Send To > Compressed (zipped) Folder" and the zip snapshot is made using the current directory name. You then update(rename) the directory to the next incremental version point and cryptic message, and you are off editing and coding again.

Over time you gather a lot of these zips. You swap and merge them with work colleagues. You had even gathered the zips into separate directories based on their major version. They languished. Finally you want a retrospective history but without too much hassle.

This is my attempt at some scripts for gathering such a history together into (eventually) a single git repo that gives a semblance of order and accessibility to that history.

This is based on using GitForWindows (which is based on the MSys/MinGW project) as the baseline toolset. This somewhat limits the available commands for use in the scripts.