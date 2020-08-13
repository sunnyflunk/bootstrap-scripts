#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource systemd
cd systemd-*

echo "[binaries]
c = 'clang'
cpp = 'clang++'
ar = 'llvm-ar'
strip = 'llvm-strip'
pkgconfig = 'pkgconf'

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
" > cross-file.txt

printInfo "Configuring systemd"
meson --prefix=/usr --buildtype=plain --cross-file cross-file.txt build


printInfo "Building systemd"
ninja -j "${SERPENT_BUILD_JOBS}" -C build


printInfo "Installing systemd"
DESTDIR="${SERPENT_INSTALL_DIR}" ninja install -j "${SERPENT_BUILD_JOBS}" -C build
