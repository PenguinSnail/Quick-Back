#!/bin/dash

SRC=/
if ! df -h $SRC > /dev/null; then
	echo "invalid source"
	echo "exiting..."
	exit 1
fi
if ! [ $SRC = "/" ]; then
	last_chr=$(echo $SRC | tail -c 2)
	if [ "$last_chr" = "/" ]; then
		echo "slash on end of source"
		SRC=${SRC%?}
	fi
fi
SRC_MNT=$(df -h $SRC | tail -n +2 | awk '{ print $6 }')
sudo btrfs subvolume list -t $SRC_MNT | tail -n +3 | awk '{ print $4 }' > /tmp/quick-back-subvolumes
while read path ; do
path=/$path
case $path in
	$SRC* )
		echo "$path exists"
	;;
esac
done < /tmp/quick-back-subvolumes

exit
