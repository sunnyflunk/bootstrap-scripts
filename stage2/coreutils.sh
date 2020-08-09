#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource coreutils
cd coreutils-*


printInfo "Configuring coreutils"
export FORCE_UNSAFE_CONFIGURE=1
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --disable-nls \
    --enable-largefile \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --enable-single-binary


printInfo "Building coreutils"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing coreutils"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
