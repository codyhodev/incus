#!/bin/bash

CONTAINER_NAME="ubuntu"

incus exec $CONTAINER_NAME -- rm /root/upload/ -rf
sleep 1
incus stop $CONTAINER_NAME --force
incus publish $CONTAINER_NAME --alias xmint --reuse --compression zstd
incus delete $CONTAINER_NAME --force