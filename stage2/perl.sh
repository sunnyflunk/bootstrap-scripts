#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource perl
cd perl-*

# Perl uses perl to compile itself so needs a working host...this fileset fixes that!
extractSource perl-cross
cp -a perl-cross-*/* .
export NM="llvm-nm"
export OBJDUMP="llvm-objdump"
export READELF="llvm-readelf"

printInfo "Configuring perl"
./configure --prefix=/usr \
    --target="${SERPENT_TRIPLET}" \
    --host="${SERPENT_HOST}" \
    -Dusethreads


printInfo "Building perl"
make -j "${SERPENT_BUILD_JOBS}"

printInfo "Installing perl"
make -j "${SERPENT_BUILD_JOBS}" install DESTDIR="${SERPENT_INSTALL_DIR}"
