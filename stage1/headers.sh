#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource linux
cd linux-*

printInfo "Configuring headers"
export ARCH="${SERPENT_ARCH}"
make mrproper
make headers
find usr/include -name '.*' -delete
rm -vf usr/include/Makefile

printInfo "Installing headers"
install -D -d -m 00755 "${SERPENT_INSTALL_DIR}/include"
cp -Rv usr/include "${SERPENT_INSTALL_DIR}/."
