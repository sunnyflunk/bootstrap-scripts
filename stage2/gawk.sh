#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource gawk
cd gawk-*


printInfo "Configuring gawk"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building gawk"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing gawk"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
