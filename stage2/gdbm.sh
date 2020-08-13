#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource gdbm
cd gdbm-*


printInfo "Configuring gdbm"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building gdbm"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing gdbm"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
