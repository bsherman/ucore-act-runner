#!/bin/sh

set -ouex pipefail

# needed for some of our CI tasks
rpm-ostree install kernel-modules-extra

# use ucore path provisioning to ensure the act runner data dir exists
echo >> /etc/systemd/ucore-paths-provision.conf
echo "0755;/var/act_data" >> /etc/systemd/ucore-paths-provision.conf

systemctl enable podman.socket
systemctl enable podman-docker-socket.service
systemctl enable podman-auto-update.timer
