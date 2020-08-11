#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource zlib
cd zlib-*


printInfo "Configuring zlib"

./configure --prefix=/usr \
    --libdir=/usr/lib \
    --enable-shared

printInfo "Building zlib"
make -j "${SERPENT_BUILD_JOBS}"

make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
