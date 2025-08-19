#!/usr/bin/bash

if [ -f incus.tar.xz ]; then
    rm incus.tar.xz -f
fi

if [ -f rootfs.* ]; then
    rm rootfs.* -f
fi