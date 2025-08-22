#!/usr/bin/bash

if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAHCE_DIR=$SCRIPT_DIR/cache

mkdir -p $CAHCE_DIR

rm -f $CAHCE_DIR/install.sh
cat > $CAHCE_DIR/install.sh << EOF
	sudo apt-get update
    sudo apt-get -y install fcitx5 fcitx5-frontend-all fcitx5-config-qt fcitx5-table fcitx5-table-wubi98 dbus-x11 --no-install-recommends
	if [ ! -f /etc/profile.d/fcitx5.sh ]; then
        sudo cp fcitx5.sh /etc/profile.d/
    fi
    rm -f install.sh
    rm -f fcitx5.sh
EOF
chmod +x $CAHCE_DIR/install.sh

rm -f $CAHCE_DIR/fcitx5.sh
cat > $CAHCE_DIR/fcitx5.sh << EOF
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    fcitx5 -d --replace  --disable=wayland,xim >/dev/null 2>&1
EOF

incus file push $CAHCE_DIR/install.sh $1/home/linux/
incus file push $CAHCE_DIR/fcitx5.sh $1/home/linux/

incus exec $1 -- su -l linux /home/linux/install.sh

rm -rf $CAHCE_DIR