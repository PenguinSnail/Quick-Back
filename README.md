# Quick-Back
A simple command-line *nix backup solution using rsync (based on git). Works best with a full system backup.

**This script is under daily development and will be frequently updated. Use with caution!**

*Currently, the only package for this script is [https://aur.archlinux.org/packages/quick-back-git](`quick-back-git` on the Arch User Repository. PR's, testing on other distros, and suggestions/issues are more than welcome. Enjoy!*

__Options__

`quick-back` takes the following command-line options. Options may not be grouped, and long- and short-form options are identical in effect.

**`quick-back` MUST be run as the root user (an effective UID of 0).**

//TODO - add a table of these

__Explanation__

The script takes a source directory **[default: `/`; change with `-s, --source *dir*`]** and uses rsync to back that directory up to a filesystem mounted at the destination **[default:  `/mnt/quick-back`; change with `-d, --destination *mountpoint*`]**. The **`-d, --destination` options can also be used with a special device file `(/dev/xxxx)`, which will be mounted to `/mnt/quick-back` with the default options.** If the destination passed is not listed in `/proc/mounts`, then an interactive prompt is displayed to avoid accidentally filling the storage.
 
As an additional precaution, the script will also check that the filesystem types in `/proc/mounts` are identical, and interactively prompt the user if they are not. The script will also offer to reformat the destination partition to match the source. Needless to say, this will destroy everything on the destination filesystem. After the format is complete, the new filesystem will be mounted to mnt/quick-back with the default options. While backing up some nonidentical filesystems (ex. ext3 -> ext4) would be harmless, other combinations could cause the loss of some special data (ex. btrfs -> ext4 will lose subvol info) or even yield a nearly useless backup (ex. ext4 -> vfat will result in the loss of all UNIX permissions). Passing the **`--force-ignore` option will silently override *both* of the above sanity checks.**

After checking the source and destination, the script proceeds to call `rsync -avpx --delete` to perform the actual backup job. **By default, `\dev`, `\proc`, `\boot`, `\tmp`, `\sys`, and `\run`, as well as the destination mountpoint, are excluded.** We are planning to implement a feature to exclude mountpoints as well.
