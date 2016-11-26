#!/bin/sh

TEMP_DIR=/tmp/quick-back-install
EXIT_CODE=0

dependencies ()
{
#search for rsync in the path
if ! which rsync &> /dev/null; then
	echo "rsync isn't installed!"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
else
	echo "rsync is installed"
fi

#search for findmnt to determine if e2fsprogs is installed
if ! which findmnt &> /dev/null; then
	echo "e2fsprogs isn't installed!"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
else
	echo "e2fsprogs is installed"
fi

#search for grep
if ! which grep &> /dev/null; then
	echo "grep is not installed!"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
else
	echo "grep is installed"
fi

#search for git
if ! which git &> /dev/null; then
	echo "git is not installed!"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
else
	echo "git is installed"
fi

#search for gzip
if ! which gzip &> /dev/null; then
	echo "gzip is not installed!"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
else
	echo "gzip is installed"
fi
}

clone_repo ()
{
echo "cloning git repository to $TEMP_DIR"
if git clone https://github.com/PenguinSnail/Quick-Back.git "$TEMP_DIR" &> /dev/null; then
	echo "repository cloned"
else
	echo "error cloning repo to temp directory"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
}

install_files ()
{
echo "installing quick-back..."
echo "copying quick-back"
if ! install -D -m 755 $TEMP_DIR/quick-back /usr/bin/quick-back &> /dev/null; then
	echo "error copying quick-back"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
echo "copying readme"
if ! install -D -m 644 $TEMP_DIR/README.md /usr/share/doc/quick-back/README.md &> /dev/null; then
	echo "error copying readme"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
echo "copying license"
if ! install -D -m 644 $TEMP_DIR/LICENSE /usr/share/doc/quick-back/LICENSE &> /dev/null; then
	echo "error copying license"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
echo "copying manpage"
if ! install -D -m 644 $TEMP_DIR/MANPAGE /usr/share/man/man8/quick-back.8 &> /dev/null; then
	echo "error copying manpage"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
echo "gziping manpage"
if ! gzip -f /usr/share/man/man8/quick-back.8 &> /dev/null; then
	echo "error gziping manpage"
	echo "exiting..."
	EXIC_CODE=1
	exit_prog
fi
}

exit_prog ()
{
echo "cleaning up..."
rm -rf $TEMP_DIR
if [ "$EXIT_CODE" = "1" ]; then
	exit 1
fi
echo "instalation finished!"
echo "run this script again to update quick-back"
exit
}

#require sudo
if [[ $EUID != 0 ]]; then
    echo "Please run with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

#Call functions
dependencies
clone_repo
install_files
exit_prog
