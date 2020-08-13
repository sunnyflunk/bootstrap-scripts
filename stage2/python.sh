#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource python
cd Python-*

# Some files aren't easily guessable during cross-compiling
export NM="llvm-nm"
export OBJDUMP="llvm-objdump"
export READELF="llvm-readelf"
echo "ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no" > config.site

printInfo "Configuring python"
CONFIG_SITE=config.site ./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --build="${SERPENT_TARGET_ARCH}" \
    --libdir=/usr/lib \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin \
    --without-cxx-main \
    --without-ensurepip \
    --with-system-expat \
    --with-system-ffi \
    --disable-ipv6


printInfo "Building python"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing python"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
