#!/bin/sh
#see http://blog.csdn.net/imfinger/article/details/6257509
#see http://tldp.org/LDP/abs/html/comparison-ops.html
if [ "$#" -ne "1" ]; then
	echo "Usage: gitcompress [git repository path]."
	exit 1
fi
gitdir="$1"
curdir=`pwd`
cd "$gitdir"
git reflog expire --expire=now --all
git gc --prune=now
cd "$curdir"
