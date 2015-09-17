#!/bin/sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This script compiles and installs mtr to /usr/local/sbin/mtr. 

# Check if mtr is already installed
MTR="/usr/local/sbin/mtr"
if [ -e "$MTR" ]; then
	echo "mtr already exists in /usr/local/sbin/mtr"
	exit 220
fi

# Check if the Xcode command line tools are installed
make 2> /dev/null
MAKE_EXISTS=$(echo $?)

if [[  "${MAKE_EXISTS}" == "1" ]] ; then
	echo "Please click Install to install the Xcode command line tools. Then run this script again."
	exit 221
fi

mkdir ~/Desktop/mtr_src
cd ~/Desktop/mtr_src/

# Install autoconf if it doesn't already exist
if ! type "autoconf" 2> /dev/null; then
	curl -O http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz || {
		echo "Failed to download autoconf."
		exit 222
	}
	tar xf autoconf-2.69.tar.xz
	cd autoconf-2.69
	./configure --prefix=/usr/local
	make
	sudo make install || {
		echo "Failed to install autoconf."
		exit 223
	}
	cd ..
fi

# Install automake if it doesn't already exist
if ! type "automake" 2> /dev/null; then
	curl -O http://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz || {
		echo "Failed to download automake."
		exit 224
	}
	tar xf automake-1.15.tar.xz
	cd automake-1.15
	./configure --prefix=/usr/local
	make
	sudo make install || {
		echo "Failed to install automake."
		exit 225
	}
	cd ..
fi

# Install mtr 
git clone https://github.com/traviscross/mtr.git || {
	echo "Failed to download mtr."
	exit 226
}
cd mtr
./bootstrap.sh
./configure --without-gtk
make
sudo make install || {
	echo "Failed to install mtr."
	exit 227
}

# Create an alias for mtr
echo "alias mtr='/usr/local/sbin/mtr'" >> ~/.bash_profile 

echo "\nmtr was successfully installed. Please relaunch the terminal."
