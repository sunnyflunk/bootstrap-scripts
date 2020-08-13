#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource make
cd make-*


printInfo "Configuring make"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building make"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing make"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"

# Include for compat purposes, may not be needed
ln -sv make "${SERPENT_INSTALL_DIR}/usr/bin/gmake"
