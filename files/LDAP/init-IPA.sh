#!/bin/sh
## Create data directory
mkdir -m 777 /var/lib/ipa-data

## Configure server
podman run  --name freeipa-server \
	-ti -e IPA_SERVER_IP=192.168.31.100 \
	-p 5353:53/udp -p 5353:53 -p  88:88/udp -p  389:389/tcp -p  123:123/udp -p 464:464/udp -p 636:636/tcp -p 88:88/tcp -p 464:464/tcp \
	-h ipa.aletia.labs \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /tmp -v /var/lib/ipa-data:/data:Z docker.io/freeipa/freeipa-server:centos-8 \
	--realm=ALETIA.LABS \
	--admin-password=aletheia \
	--no-ntp --setup-dns \
	--forwarder 192.168.131.10 \
	--forwarder 192.168.131.1 \
	-p aletheia --ip-address=192.168.131.100
