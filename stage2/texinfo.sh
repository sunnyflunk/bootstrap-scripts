#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource texinfo
cd texinfo-*


printInfo "Configuring texinfo"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building texinfo"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing texinfo"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
