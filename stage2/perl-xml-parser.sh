#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource perl-xml-parser
cd XML-Parser-*


printInfo "Configuring perl-xml-parser"
perl -I"${SERPENT_ROOT_DIR}/install/stage2" Makefile.PL PREFIX=/usr INSTALLDIRS=vendor DESTDIR="${SERPENT_INSTALL_DIR}"

printInfo "Building perl-xml-parser"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing perl-xml-parser"
#make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
