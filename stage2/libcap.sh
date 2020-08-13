#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource libcap
cd libcap-*


printInfo "Building libcap"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing libcap"
make -j "${SERPENT_BUILD_JOBS}" install RAISE_SETFCAP=no prefix=/usr DESTDIR="${SERPENT_INSTALL_DIR}"
