# Quick-Back

[![Build Status](https://travis-ci.org/PenguinSnail/Quick-Back.svg?branch=master)](https://travis-ci.org/PenguinSnail/Quick-Back)

A simple command-line, POSIX-compliant, *nix backup solution using rsync. Works best with a full system backup.

***This script is under daily development and will be frequently updated. Use with caution!***

*Currently, the only package for this script is [`quick-back-git`](https://aur.archlinux.org/packages/quick-back-git) on the Arch User Repository. PR's, testing on other distros, and suggestions/issues are more than welcome. Enjoy!*

*You can join the mailing list for feature announcements and support by emailing `quickback-request@freelists.org` with `subscribe` in the Subject field OR by visiting [http://www.freelists.org/list/quickback](http://www.freelists.org/list/quickback).*

*Join us on Slack at [https://quickdevs.slack.com](https://quickdevs.slack.com)*

## Required Dependencies

`git`: Required to run the install script

`rsync`: Required for the core backup functionality

`util-linux`: Required to detect filesystem information using the `findmnt` command

`coreutils`: Required to detect filesystem information using the `df` command

`grep`: Required for certain detection functions

## Installing

If you are running ArchLinux, you have the benefit of the Arch User Repository, and can get `quick-back` under the [`quick-back-git`](https://aur.archlinux.org/packages/quick-back-git) package.

If you are on another linux distro, you can install the most recent version of `quick-back` by running the included `install.sh` script as root. This can be done by executing the following command:

`curl -O https://raw.githubusercontent.com/PenguinSnail/Quick-Back/master/install.sh && chmod +x install.sh && sudo ./install.sh`

or

`wget https://raw.githubusercontent.com/PenguinSnail/Quick-Back/master/install.sh && chmod +x install.sh && sudo ./install.sh`

If you ever want to update `quick-back`, run the `install.sh` command again!

## Usage

`quick-back [option] <argument>`

`quick-back` **MUST be run as the root user or with sudo** ***(for an effective UID of 0).***

## Options

Options **MUST** be passed separately.

`-s, --source-dir <path>`: This option will change the directory for `quick-back` to back up **from** to `<path>` (By default it is `/`) This option will only work with directories and not `/dev/XXX` device files

`-d, --destination <path>`: This  option will change the destination for `quick-back` to back up **to** to `<path>`, which can be either a directory or a special `/dev/XXX` device. If `<path>` is a `/dev/XXX` device it must already have a filesystem and be mountable. If `<path>` is a directory, it must be a mountpoint, if it isn't a mountpoint the script will not run.

`-e, --exclude <path>`: This option excludes aditional paths relative to the source directory. Multiple paths can be excluded if multiple option flags are used.

`-nd, --nodefaults`: This options omits passing rsync the default excludes below (the dest. mountpoint is always excluded, as are any user specified excludes).

`-v, --verbose`: This option runs `quick-back` in verbose mode, displaying every file being modified on the backup

`-c, --color`: This option will colorize the output of `quick-back`

`--force-ignore`: This option will force-override the sanity checks.

**Default Excludes: `/boot/, /run/*, /proc/*, /tmp/*, /sys/*, /dev/*, /mnt/*, media/*`**

## Sanity Checks

*The following checks can be overridden by passing the `--force-ignore` option. Please read the below explanation before doing so.*

While backing up some nonidentical filesystems (ex. ext3 -> ext4) would be harmless, other combinations could cause the loss of some special data (ex. btrfs -> ext4 will lose subvol info) or even yield a nearly useless backup (ex. ext4 -> vfat will result in the loss of all UNIX permissions). Accordingly, the script checks for this and will prompt the user to automatically reformat the destination. After the format is complete, the new filesystem will be mounted to /mnt/quick-back with the default options.

It should also be noted that if a cross-filesystem backup is made, the backup will not be able to boot, requiring the backups initramfs to be remade.

Also, if the directory is *neither* a mountpoint nor a device file, the the script will prompt for confirmation as the backup will not be going anywhere.

## The Backup

After checking the source and destination, the script proceeds to call `rsync -apx --delete --no-i-r --info=progress2` to perform the actual backup job. The `-d, -nd` switches control whether a list (see above) of default `--excludes` are added to the command. For sanity, the destination mountpoint is always excluded. A feature to exclude other mountpoints is in the works as well.

If there is a `boot` subdirectory of the source, then `boot/vmlinuz` and `boot/initramfs` will be backed up, but no other files will. On many systems, this may not be suffecient to make the backup bootable. Please ensure that you have manally verified that your backup can actually boot.

## Current Bugs/Issues

* Limited `btrfs` source support:
  * Subvolumes that are visible without unmounting anything on the source will be backed up, but there may be unforseen errors
* If backed up the `/etc/fstab` file isn't modified, making the backup un-bootable until manually updated

Again, PR's are welcome!
