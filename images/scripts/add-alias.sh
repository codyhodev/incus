#!/bin/bash

incus alias remove bash || true
incus alias add bash "exec @ARGS@  -- su - linux"