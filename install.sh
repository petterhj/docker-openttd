#!/bin/bash

set -x # trace the execution of all commands
set -e # exit on errors

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Update package repos
echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list

apt update -qq # -qq for (more) silent

## Install packages
apt install -yqq --no-install-recommends \
    -o DPkg::Options::=--force-confold \
    -o DPkg::Options::=--force-confdef \
    dumb-init wget unzip ca-certificates \
    libfontconfig1 libfreetype6 libfluidsynth2 \
    libicu-dev libpng16-16 liblzma-dev liblzo2-2 \
    libsdl1.2debian libsdl2-2.0-0

## Download and install OpenTTD
wget -q https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-ubuntu-${UBUNTU_CODENAME}-amd64.deb
dpkg -i openttd-${OPENTTD_VERSION}-linux-ubuntu-${UBUNTU_CODENAME}-amd64.deb

mkdir -p /usr/share/games/openttd/baseset/
cd /usr/share/games/openttd/baseset/
wget -q -O opengfx-${OPENGFX_VERSION}.zip https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip

unzip opengfx-${OPENGFX_VERSION}.zip
tar -xf opengfx-${OPENGFX_VERSION}.tar
rm -rf opengfx-*.tar opengfx-*.zip

## Create user
adduser \
    --disabled-password \
    --uid 1000 \
    --shell /bin/bash \
    --gecos "" openttd
addgroup openttd users

chmod +x /openttd.sh
