#!/usr/bin/env bash
set -eux

apt-get update
apt-get install -y openssh-server

systemctl enable --now ssh
