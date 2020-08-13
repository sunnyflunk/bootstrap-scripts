#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource meson
cd meson-*


printInfo "Building meson"
python3 setup.py build

printInfo "Installing meson"
python3 setup.py install --root="${SERPENT_INSTALL_DIR}"
