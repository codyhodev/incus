#!/usr/bin/bash

CURDIR=$(cd $(dirname $0); pwd)

dpkg -i $CURDIR/*.deb
install -o root -g root -m 644 $CURDIR/official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list
install -o root -g root -m 644 $CURDIR/official-extra-repositories.pref /etc/apt/preferences.d/official-extra-repositories.pref
install -o root -g root -m 644 $CURDIR/official-package-repositories.pref /etc/apt/preferences.d/official-package-repositories.pref
install -o root -g root -m 644 $CURDIR/nosnap.pref /etc/apt/preferences.d/nosnap.pref
install -o root -g root -m 644 $CURDIR/xmint-fcitx.service /usr/lib/systemd/user/xmint-fcitx.service
install -o root -g root -m 644 $CURDIR/xmint-linger.service /usr/lib/systemd/user/xmint-linger.service
install -o root -g root -m 644 $CURDIR/env.sh /etc/profile.d/99-xmint-env.sh

rm /etc/apt/preferences.d/ubuntu-pro-esm-apps -f
rm /etc/apt/preferences.d/ubuntu-pro-esm-infra -f
rm /etc/apt/sources.list.d/ubuntu.sources -f

apt-get update
apt-get -y install libatomic1 pavucontrol libpulse0 language-pack-zh-hans fonts-noto-cjk fonts-liberation nano git wget curl htop psmisc dbus-x11 rtkit pipewire nemo xed xdg-desktop-portal xdg-desktop-portal-gtk  --no-install-recommends
apt-get -y install xed nemo fcitx fcitx-frontend-all fcitx-table fcitx-table-wubi


mkdir -p /etc/systemd/user/default.target.wants
ln -s /usr/lib/systemd/user/xmint-fcitx.service /etc/systemd/user/default.target.wants/xmint-fcitx.service
ln -s /usr/lib/systemd/user/xmint-linger.service /etc/systemd/user/default.target.wants/xmint-linger.service

userdel ubuntu -r -f
rm /etc/sudoers.d/90-cloud-init-users -f

useradd --create-home -s /bin/bash -U linux -u 1000
echo "linux ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-linux-user

sleep 1          
loginctl enable-linger linux
