#!/usr/bin/bash

incus image delete mint-container || true
incus image import incus.tar.xz rootfs.squashfs --alias mint-container
