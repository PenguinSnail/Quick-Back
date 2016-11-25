#!/bin/bash

SRC=/var

sudo btrfs subvolume list -t / | tail -n +3 | awk '{ print $4 }' > /tmp/quick-back-subvolumes
while read path ; do
	if [ -d "$SRC"/"$path" ]; then
		echo "/$path subvolume exists in source"
	fi
done < /tmp/quick-back-subvolumes

exit
