#!/usr/bin/bash

if [ -f incus.tar.xz ]; then
    rm incus.tar.xz -f
fi

if [ -f rootfs.* ]; then
    rm rootfs.* -f
fi

sudo distrobuilder --cleanup=true --cache-dir=./cache  build-incus  image.yaml  -o image.architecture=amd64 -o image.release=noble -o image.variant=cloud