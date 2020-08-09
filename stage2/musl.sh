#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource musl
cd musl-*


printInfo "Configuring musl"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-optimize=auto \
    --enable-visibility

printInfo "Building musl"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing musl"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"

printInfo "Installing ldd"
ln -sv ../lib/libc.so "${SERPENT_INSTALL_DIR}/usr/bin/ldd"
