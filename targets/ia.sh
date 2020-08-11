#!/bin/true

. $(dirname $(realpath -s $0))/../lib/base.sh


export SERPENT_TARGET_CFLAGS="-march=haswell -mtune=skylake -O3 -fPIC"
export SERPENT_TARGET_CXXFLAGS="${SERPENT_TARGET_CFLAGS}"
export SERPENT_TRIPLET="x86_64-serpent-linux-musl"
