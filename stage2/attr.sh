#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource attr
cd attr-*


printInfo "Configuring attr"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-shared \
    --disable-static \
    --libdir=/usr/lib \

printInfo "Building attr"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing attr"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
