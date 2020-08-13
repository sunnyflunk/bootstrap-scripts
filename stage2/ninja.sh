#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource ninja
cd ninja-*


printInfo "Configuring ninja"
cmake .


printInfo "Building ninja"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing ninja"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
