# Quick-Back
A simple command-line, POSIX-compliant, *nix backup solution using rsync. Works best with a full system backup.

***This script is under daily development and will be frequently updated. Use with caution!***

*Currently, the only package for this script is [`quick-back-git`](https://aur.archlinux.org/packages/quick-back-git) on the Arch User Repository. PR's, testing on other distros, and suggestions/issues are more than welcome. Enjoy!*


__Required Dependencies__

`git`: Required to run the install script

`rsync`: Required for the core backup functionality

`util-linux`: Required to detect filesystem information using the `findmnt` command

`coreutils`: Required to detect filesystem information using the `df` command

`grep`: Required for certain detection functions

__Installing__

If you are running ArchLinux, you have the benefit of the Arch User Repository, and can get `quick-back` under the [`quick-back-git`](https://aur.archlinux.org/packages/quick-back-git) package.

If you are on another linux distro, you can install the most recent version of `quick-back` by running the included `install.sh` script as root. This can be done by executing the following commands:

`git clone https://www.github.com/PenguinSnail/Quick-Back.git`
`cd Quick-Back`
`sudo ./install.sh`

If you ever want to update `quick-back`, run the `install.sh` command again

__Usage__

`quick-back [option] <argument>` 

`quick-back` **MUST be run as the root user or with sudo (for an effective UID of 0).**

__Options__

Options **MUST** be passed separately.

`-s, --source-dir <path>`: This option will change the directory for `quick-back` to back up **from** to `<path>` (By default it is `/`) This option will only work with directories and not `/dev/XXX` device files

`-d, --destination <path>`: This  option will change the destination for `quick-back` to back up **to** to `<path>`, which can be either a directory or a special `/dev/XXX` device. If `<path>` is a `/dev/XXX` device it must already have a filesystem and be mountable. If `<path>` is a directory, it must be a mountpoint, if it isn't a mountpoint the script will not run.

`-e, --exclude <path>`: This option can exclude one aditional path from the backup and can only be used once.

`--force-ignore`: This option will force-override the sanity checks.

__Sanity Checks__

*The following checks can be overridden by passing the `--force-ignore` option. Please read the below explanation before doing so.*

While backing up some nonidentical filesystems (ex. ext3 -> ext4) would be harmless, other combinations could cause the loss of some special data (ex. btrfs -> ext4 will lose subvol info) or even yield a nearly useless backup (ex. ext4 -> vfat will result in the loss of all UNIX permissions). Accordingly, the script checks for this and will prompt the user to automatically reformat the destination. After the format is complete, the new filesystem will be mounted to /mnt/quick-back with the default options. 

It should also be noted that if a cross-filesystem backup is made, the backup will not be able to boot, requiring the backups initramfs to be remade.

Also, if the directory is *neither* a mountpoint nor a device file, the the script will prompt for confirmation as the backup will not be going anywhere.

__The Backup__

After checking the source and destination, the script proceeds to call `rsync -avpx --delete` to perform the actual backup job. By default, `/dev`, `/proc`, `/boot`, `/tmp`, `/sys`, and `/run`, as well as the destination mountpoint, are excluded. A feature to exclude other mountpoints is in the works as well.

If there is a `boot` subdirectory of the source, then `boot/vmlinuz` and `boot/initramfs` will be backed up, but no other files will. On many systems, this may not be suffecient to make the backup bootable. Please ensure that you have manally verified that your backup can actually boot.

__Current Bugs/Issues__

* Source filesystem mount options are not preserved when the backup is mounted if specifying a `/dev/XXX` device
* Limited `btrfs` source support:
  * Subvolumes that are visible without unmounting anything on the source will be backed up, but there may be unforseen errors
  * Source filesystems mounted with the `nodatacow` option will lose this attribute on the backup<br>*Please recall that this atrribute can not be reset on the backup easily as it is impossible to disable CoW on existing files. Proper support is being worked on in a seperate branch, but this is not yet ready for production.*
* The `-e` option can only be passed once

Again, PR's are welcome!
