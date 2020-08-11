#!/bin/true

. $(dirname $(realpath -s $0))/../lib/base.sh


export SERPENT_TARGET_CFLAGS="-march=haswell -mtune=skylake -O3 -fPIC -mprefer-vector-width=128"
export SERPENT_TARGET_CXXFLAGS="${SERPENT_TARGET_CFLAGS}"
export SERPENT_TARGET_LDFLAGS=""
export SERPENT_TRIPLET="x86_64-serpent-linux-musl"
