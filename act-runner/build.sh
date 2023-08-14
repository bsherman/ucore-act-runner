#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# add packages desired for dev
rpm-ostree install \
  bind-utils \
  cargo \
  ccache \
  cpio \
  dosfstools \
  file \
  fuse \
  gcc \
  hugo \
  just \
  nodejs \
  patch \
  python-unversioned-command \
  python3-pip \
  python3-virtualenv \
  rust \
  syslinux \
  xorriso \
  yamllint

./gitea-release-download.sh gitea/act_runner linux-amd64 /usr/bin/act_runner
chmod a+xr /usr/bin/act_runner