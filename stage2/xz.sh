#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource xz
cd xz-*


printInfo "Configuring xz"
# Enable largefile support
export CFLAGS="${CFLAGS} -D_FILE_OFFSET_BITS=64"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-shared \
    --disable-static \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building xz"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing xz"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
