#!/bin/bash

CONTAINER_NAME="ubuntu"
IMAGE_NAME="images:ubuntu/24.04/cloud/amd64"

incus launch $IMAGE_NAME $CONTAINER_NAME
incus exec $CONTAINER_NAME -- cloud-init status --wait
incus file push upload $CONTAINER_NAME/root/ -r
incus exec $CONTAINER_NAME -- bash /root/upload/setup.sh