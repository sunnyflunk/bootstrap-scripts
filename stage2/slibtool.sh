#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource slibtool
cd slibtool-*


printInfo "Configuring slibtool"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --all-static


printInfo "Building slibtool"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing slibtool"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"

# Attempt to use slibtool for all libtool purposes
ln -sv slibtool "${SERPENT_INSTALL_DIR}/usr/bin/libtool"
