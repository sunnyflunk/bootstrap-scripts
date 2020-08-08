#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource musl
cd musl-*

export PATH="${SERPENT_INSTALL_DIR}/usr/bin:$PATH"
export CC="clang"
export CXX="clang++"

printInfo "Configuring musl"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-optimize=auto \
    --enable-visibility \
    AR="llvm-ar" \
    RANLIB="llvm-ranlib" \
    STRIP="llvm-strip"

printInfo "Building musl"
make -j "${SERPENT_BUILD_JOBS}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip"

printInfo "Installing musl"
make -j "${SERPENT_BUILD_JOBS}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip" install DESTDIR="${SERPENT_INSTALL_DIR}"
