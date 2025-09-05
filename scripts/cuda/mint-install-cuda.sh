#!/usr/bin/bash

CUDA_PKG="cuda_12.5.1_555.42.06_linux.run"
CUDNN_FILENAME="cudnn-linux-x86_64-9.11.0.98_cuda12-archive"
CUDNN_PKG="$CUDNN_FILENAME.tar.xz"


set -e

if [ "$1" = "" ]; then
	echo 请输入容器实例名称!
	exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAHCE_DIR=$SCRIPT_DIR/cache
mkdir -p $CAHCE_DIR

if [ ! -f $CAHCE_DIR/$CUDA_PKG ]; then
    echo "missing file $CAHCE_DIR/$CUDA_PKG !"
    exit -1
fi

if [ ! -f $CAHCE_DIR/$CUDNN_PKG ]; then
    echo "missing file $CAHCE_DIR/$CUDNN_PKG !"
    exit -1
fi

rm -rf $CAHCE_DIR/cuda.sh
cat > $CAHCE_DIR/cuda.sh << EOF
export CUDA_HOME=/usr/local/cuda
export PATH=\$CUDA_HOME/bin:\$PATH
export LD_LIBRARY_PATH=\$CUDA_HOME/lib:\$CUDA_HOME/lib64:\$LD_LIBRARY_PATH
export TF_ENABLE_ONEDNN_OPTS=0
EOF

rm -f $CAHCE_DIR/install.sh
cat > $CAHCE_DIR/install.sh << EOF
sudo rm -rf /usr/local/cuda*
sudo rm -f /etc/profile.d/cuda.sh
cd /home/linux/cuda/
sudo cp cuda.sh /etc/profile.d/
sudo sh $CUDA_PKG --silent --toolkit --no-man-page --override
tar -xvf $CUDNN_PKG
sudo cp -r $CUDNN_FILENAME/include/* /usr/local/cuda/include/
sudo cp -r $CUDNN_FILENAME/lib/ /usr/local/cuda/

rm -rf /home/linux/cuda
EOF
chmod +x $CAHCE_DIR/install.sh

for file in $CAHCE_DIR/*
do
    incus file push $file $1/home/linux/cuda/ -p
done

incus exec $1 -- su -l linux /home/linux/cuda/install.sh


