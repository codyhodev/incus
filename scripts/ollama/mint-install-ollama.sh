#!/usr/bin/bash
VER=v0.11.6
PROXY=https://gh.llkk.cc/
URL=https://github.com/ollama/ollama/releases/download/$VER/ollama-linux-amd64.tgz
PKG=$(basename $URL)

set -e

if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

incus config set $1 nvidia.runtime true
incus config set $1 nvidia.driver.capabilities=all
incus config set $1 boot.autostart false
incus config set $1 boot.host_shutdown_action stop

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAHCE_DIR=$SCRIPT_DIR/cache
mkdir -p $CAHCE_DIR

#rm -f $CAHCE_DIR/$PKG
if [ ! -f $CAHCE_DIR/$PKG ]; then
    curl $PROXY$URL -o $CAHCE_DIR/$PKG
fi

rm -f $CAHCE_DIR/install.sh
cat > $CAHCE_DIR/install.sh << EOF
#!/usr/bin/bash
set -e

tar -C /usr -xzf $PKG
rm -f $PKG

useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
usermod -a -G ollama linux

cat > /etc/systemd/system/ollama.service  << EOF0
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"

[Install]
WantedBy=default.target
EOF0

systemctl daemon-reload
systemctl enable ollama

rm -f install.sh
EOF

chmod +x $CAHCE_DIR/install.sh

incus file push $CAHCE_DIR/$PKG $1/root/
incus file push $CAHCE_DIR/install.sh $1/root/
incus exec $1 -- /root/install.sh
incus restart $1
