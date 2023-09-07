#!/bin/sh

set -ouex pipefail

systemctl enable podman.socket
systemctl enable podman-docker-socket.service

