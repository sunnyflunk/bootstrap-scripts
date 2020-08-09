#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource util-linux
cd util-linux-*


printInfo "Configuring util-linux"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    --disable-nls \
    --without-systemd \
    --without-udev \
    --without-python \
    --without-tinfo \
    --without-libmagic \
    --without-ncurses \
    --without-ncursesw \
    --without-readline \
    --without-cryptsetup \
    --without-btrfs \
    --without-audit \
    --without-user \
    --without-selinux \
    --without-smack \
    --enable-largefile \
    --disable-plymouth_support \
    --libdir=/usr/lib \
    --disable-rpath \
    --disable-makeinstall-chown \
    --disable-makeinstall-setuid \
    --bindir=/usr/bin \
    --sbindir=/usr/sbin


printInfo "Building util-linux"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing util-linux"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
