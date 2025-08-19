#!/usr/bin/bash

incus alias add bash "exec @ARGS@  -- su -l linux"
incus alias add create-mint-server "launch cn-images:ubuntu/24.04/cloud/amd64 @ARGS@ -p mint-server-rev"
