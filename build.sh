#!/bin/sh

set -ouex pipefail

# use ucore path provisioning to ensure the act runner data dir exists
echo >> /etc/systemd/ucore-paths-provision.conf
echo "0755;/var/act_data" >> /etc/systemd/ucore-paths-provision.conf

# install pcp stuff for testing
rpm-ostree install cockpit-pcp pcp-system-tools

systemctl enable podman.socket
systemctl enable podman-docker-socket.service

