#!/usr/bin/bash

start-proxy-host(){
    #xhost +local: || true
	if incus ls -f csv | grep -q '^local-proxy,RUNNING'; then
		echo "proxy container is running."
	else
		incus start local-proxy
	fi
}

start-proxy-app(){
	if incus exec local-proxy -- su -l linux -c 'pgrep -fl ^clash-verge$' ;then
		echo "clash-verge is running."
	else
		incus exec local-proxy -- su -l linux -c 'clash-verge > /dev/null 2>&1'
	fi
}

start-proxy-host
start-proxy-app


