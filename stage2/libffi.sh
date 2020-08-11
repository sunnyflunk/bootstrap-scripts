#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource libffi
cd libffi-*


printInfo "Configuring libffi"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \


printInfo "Building libffi"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing libffi"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
