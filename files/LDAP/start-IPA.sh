#!/bin/sh
## Create IPA server
podman run  -d --name freeipa-server-container -ti \
	-e IPA_SERVER_IP=192.168.131.100 \
	-p 5353:53/udp -p 5353:53 -p  88:88/udp -p  389:389 -p  123:123/udp -p 464:464/udp -p 636:636 -p 88:88 -p 464:464 \
	-h ipa.aletia.labs \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /var/lib/ipa-data:/data:Z \
	docker.io/freeipa/freeipa-server:centos-8
