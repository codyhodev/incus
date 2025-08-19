#!/usr/bin/bash


if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

if [ ! -f $(pwd)/cuda_11.4.4_470.82.01_linux.run ]; then
	wget https://developer.download.nvidia.com/compute/cuda/11.4.4/local_installers/cuda_11.4.4_470.82.01_linux.run || exit -1
fi


incus launch mint-container $1 -p mint-server -c nvidia.runtime=true -c nvidia.driver.capabilities=all || exit -1
incus exec $1 -- cloud-init status --wait
incus config device add $1 gpu0 gpu pci="0000:01:00.0" || exit -1
incus file push $(pwd)/cuda_11.4.4_470.82.01_linux.run $1/root/
incus file push $(pwd)/install-cuda.sh $1/root/
incus exec $1 -- /root/install-cuda.sh
incus config set $1 boot.autostart false
incus config set $1 boot.host_shutdown_action stop
incus restart $1
