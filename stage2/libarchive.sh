#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource libarchive
cd libarchive-*


printInfo "Configuring libarchive"
# Enable largefile support
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --enable-shared \
    --disable-static \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --without-xml2 \
    --without-openssl \
    --without-expat \
    --disable-rpath \
    --enable-largefile \


printInfo "Building libarchive"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing libarchive"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"

printInfo "Making bsdtar default tar implementation"
ln -sv bsdtar "${SERPENT_INSTALL_DIR}/usr/bin/tar"

printInfo "Making bsdtar default cpio implementation"
ln -sv bsdcpio "${SERPENT_INSTALL_DIR}/usr/bin/cpio"
