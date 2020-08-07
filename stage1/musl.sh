#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource musl
cd musl-*

export PATH="${SERPENT_INSTALL_DIR}/usr/bin:$PATH"

printInfo "Configuring musl"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    AR="llvm-ar" \
    RANLIB="llvm-ranlib" \
    STRIP="llvm-strip"

printInfo "Building musl"
make -j "${SERPENT_BUILD_JOBS}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip"

printInfo "Installing musl"
make -j "${SERPENT_BUILD_JOBS}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip" install DESTDIR="${SERPENT_INSTALL_DIR}"
