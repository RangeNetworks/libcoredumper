#!/bin/bash

VERSION=1.2.1

sayAndDo () {
	echo $@
	eval $@
	if [ $? -ne 0 ]
	then
		echo "ERROR: command failed!"
		exit 1
	fi
}

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo " - oops, missing $@, installing"
		sudo apt-get install $@
	else
		echo " - $@ ok"
	fi
	echo
}

if [ ! -f coredumper-$VERSION.tar.gz ]
then
	sayAndDo wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-coredumper/coredumper-$VERSION.tar.gz
fi

if [ -d coredumper-$VERSION ]
then
	sayAndDo rm -rf coredumper-$VERSION
fi

sayAndDo tar zxf coredumper-$VERSION.tar.gz
sayAndDo cd coredumper-$VERSION
sayAndDo mv packages/deb debian
sayAndDo chmod 644 debian/control
sayAndDo patch -p0 < ../fix_from_scratch_build.patch
sayAndDo dpkg-buildpackage -us -uc

