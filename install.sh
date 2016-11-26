#!/bin/sh

if ! which rsync &> /dev/null; then
	echo "rsync isn't installed!"
	echo "exiting..."
	exit 1
else
	echo "rsync is installed"
fi

if ! which findmnt &> /dev/null; then
	echo "e2fsprogs isn't installed!"
	echo "exiting..."
	exit 1
else
	echo "e2fsprogs is installed"
fi

if ! which grep &> /dev/null; then
	echo "grep is not installed!"
	echo "exiting..."
	exit 1
else
	echo "grep is installed"
fi
