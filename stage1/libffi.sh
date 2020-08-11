#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource libffi
cd libffi-*

export PATH="${SERPENT_INSTALL_DIR}/usr/bin:$PATH"
export CC="clang"
export CXX="clang++"

export CFLAGS="${SERPENT_TARGET_CFLAGS}"
export CXXFLAGS="${SERPENT_TARGET_CXXFLAGS}"

printInfo "Configuring libffi"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    AR="llvm-ar" \
    RANLIB="llvm-ranlib" \
    STRIP="llvm-strip"


printInfo "Building libffi"
make -j "${SERPENT_BUILD_JOBS}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip"

printInfo "Installing libffi"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}" AR="llvm-ar" RANLIB="llvm-ranlib" STRIP="llvm-strip"
