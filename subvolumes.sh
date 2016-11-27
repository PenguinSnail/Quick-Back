#!/bin/dash

SRC=/
echo $SRC
sudo btrfs subvolume list -t / | tail -n +3 | awk '{ print $4 }' > /tmp/quick-back-subvolumes
while read path ; do
path=/$path
case $path in
	$SRC* )
		echo "$path exists"
	;;
esac
done < /tmp/quick-back-subvolumes

exit
