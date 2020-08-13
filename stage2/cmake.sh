#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource cmake
cd cmake-*


printInfo "Configuring cmake"
cmake .

printInfo "Building cmake"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing cmake"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
