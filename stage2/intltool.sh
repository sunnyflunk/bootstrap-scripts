#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource intltool
cd intltool-*

patch -p1 < "${SERPENT_PATCHES_DIR}/intltool_perlfix.patch"

printInfo "Configuring intltool"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building intltool"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing intltool"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
