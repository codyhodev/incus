#!/usr/bin/bash

set -e

if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

incus config set $1 security.nesting true
incus config set $1 security.syscalls.intercept.mknod true
incus config set $1 security.syscalls.intercept.setxattr true
incus restart $1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAHCE_DIR=$SCRIPT_DIR/cache
mkdir -p $CAHCE_DIR

rm -f $CAHCE_DIR/install.sh
cat > $CAHCE_DIR/install.sh << EOF
set -e

#proxy 
#export https_proxy=socks://192.168.122.96:7898

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings

sudo rm -f /etc/apt/keyrings/docker.asc
sudo cp ~/docker/docker.asc /etc/apt/keyrings/
sudo chmod a+r /etc/apt/keyrings/docker.asc


# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update	
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sleep 5s

#sudo groupadd docker
sudo usermod -aG docker linux

sudo mkdir -p /etc/docker
sudo rm -f  /etc/docker/daemon.json
sudo cp ~/docker/daemon.json /etc/docker/

sudo systemctl daemon-reload
sudo systemctl restart docker

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts


rm -rf ~/docker
EOF

cat > $CAHCE_DIR/daemon.json << EOF
{
"registry-mirrors": [
    "https://docker.1ms.run"
  ]
}
EOF

chmod +x $CAHCE_DIR/install.sh

for file in $CAHCE_DIR/*.*
do
    incus file push $file $1/home/linux/docker/ -p
done
incus file push docker.asc $1/home/linux/docker/ -p

incus exec $1 -- su -l linux /home/linux/docker/install.sh
incus restart $1