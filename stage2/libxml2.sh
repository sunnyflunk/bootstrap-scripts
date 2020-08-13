#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource libxml2
cd libxml2-*


printInfo "Configuring libxml2"
autoreconf -vfi
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --without-python


printInfo "Building libxml2"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing libxml2"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
