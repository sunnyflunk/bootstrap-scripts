#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource ncurses
cd ncurses-*


printInfo "Configuring ncurses"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --without-debug \
    --without-profile \
    --disable-rpath \
    --with-shared \
    --without-ada \
    --without-normal \
    --enable-widec \
    --enable-largefile \
    --disable-db-install \
    --enable-symlinks \
    --with-pkg-config-libdir=/usr/lib/pkgconfig \
    PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig


printInfo "Building ncurses"
make -j "${SERPENT_BUILD_JOBS}"

# We don't use tic in this step, however.
make -j "${SERPENT_BUILD_JOBS}" install TIC_PATH=$(pwd)/progs/tic  DESTDIR="${SERPENT_INSTALL_DIR}"

for item in "clear" "captoinfo" "infocmp" "infotocap" "reset" "tabs" "tic" "toe" "tput" "tset" ; do
    ln -sv "${SERPENT_TRIPLET}-${item}" "${SERPENT_INSTALL_DIR}/usr/bin/${item}"
done
