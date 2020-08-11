#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource openssl
cd openssl-*


printInfo "Configuring openssl"
./config --prefix=/usr --openssldir=/etc/ssl shared zlib-dynamic


printInfo "Building openssl"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing openssl"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
