#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource acl
cd acl-*


printInfo "Configuring acl"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-shared \
    --disable-static \
    --libdir=/usr/lib \

printInfo "Building acl"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing acl"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
