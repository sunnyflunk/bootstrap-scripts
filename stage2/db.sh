#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource db
cd db-*

patch -p1 < "${SERPENT_PATCHES_DIR}/db_atomic.patch"

printInfo "Configuring db"
dist/configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building db"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing db"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
