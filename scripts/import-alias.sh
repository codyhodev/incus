#!/usr/bin/bash

incus alias remove bash || true
incus alias add bash "exec @ARGS@  -- su - linux"
incus alias remove create-mint-server || true
incus alias add create-mint-server "launch cn-images:ubuntu/24.04/cloud/amd64 @ARGS@ -p mint-server"
incus alias remove create-mint-desktop || true
incus alias add create-mint-desktop "launch cn-images:ubuntu/24.04/cloud/amd64 @ARGS@ -p mint-desktop"
incus alias remove code || true
incus alias add code "exec @ARGS@  -- su - linux /usr/bin/code"
incus alias remove chrome || true
incus alias add chrome "exec @ARGS@  -- su - linux  /usr/bin/google-chrome"
