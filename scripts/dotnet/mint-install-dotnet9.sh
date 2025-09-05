#!/usr/bin/bash
VER=9.0.304
URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/$VER/dotnet-sdk-$VER-linux-x64.tar.gz"
PKG=$(basename $URL)
set -e

if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAHCE_DIR=$SCRIPT_DIR/cache
mkdir -p $CAHCE_DIR

if [ ! -f $CAHCE_DIR/$PKG ]; then
	axel -n 5 $URL -o $CAHCE_DIR/$PKG
fi

rm -f $CAHCE_DIR/dotnet.sh
cat > $CAHCE_DIR/dotnet.sh << EOF
	export DOTNET_ROOT=\$HOME/.dotnet_home
	export PATH=\$PATH:\$HOME/.dotnet_home
EOF

rm -f $CAHCE_DIR/install.sh
cat > $CAHCE_DIR/install.sh << EOF
    cd ~/dotnet9
	mkdir -p \$HOME/.dotnet_home && tar zxf $PKG  -C \$HOME/.dotnet_home
	if [ ! -f /etc/profile.d/dotnet.sh ];then
		sudo cp dotnet.sh /etc/profile.d/
	fi
	rm -rf ~/dotnet9
EOF
chmod +x $CAHCE_DIR/install.sh

for file in $CAHCE_DIR/*
do
	incus file push $file $1/home/linux/dotnet9/ -p
done

incus exec $1 -- su - linux /home/linux/dotnet9/install.sh
