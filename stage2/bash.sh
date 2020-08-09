#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource bash
cd bash-*


printInfo "Configuring bash"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --without-bash-malloc \
    --disable-nls


printInfo "Building bash"
make -j "${SERPENT_BUILD_JOBS}"

make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
ln  -s bash "${SERPENT_INSTALL_DIR}/usr/bin/sh"
