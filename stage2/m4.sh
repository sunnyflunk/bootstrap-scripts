#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource m4
cd m4-*


printInfo "Configuring m4"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building m4"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing m4"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
