#!/bin/bash

sudo btrfs subvolume list -t / | tail -n +3 | awk '{ print $4 }'

exit
