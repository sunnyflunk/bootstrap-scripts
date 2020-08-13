#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource patch
cd patch-*


printInfo "Configuring patch"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building patch"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing patch"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
