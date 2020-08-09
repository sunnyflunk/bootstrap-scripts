#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

printInfo "Configuring root filesystem layout"

install -v -D -d -m 00755 "${SERPENT_INSTALL_DIR}"/usr/{bin,lib,share,sbin,include}
install -v -D -d -m 00755 "${SERPENT_INSTALL_DIR}"/{etc,proc,run,var}

install -v -D -d -m 00755 "${SERPENT_INSTALL_DIR}/run/lock"
ln -sv ../run/lock "${SERPENT_INSTALL_DIR}/var/lock"

ln -sv lib "${SERPENT_INSTALL_DIR}/usr/lib64"
ln -sv usr/bin "${SERPENT_INSTALL_DIR}/bin"
ln -sv usr/sbin "${SERPENT_INSTALL_DIR}/sbin"
ln -sv usr/lib "${SERPENT_INSTALL_DIR}/lib"
ln -sv usr/lib64 "${SERPENT_INSTALL_DIR}/lib64"
