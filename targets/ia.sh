#!/bin/true

export SERPENT_TARGET_CFLAGS="-march=haswell -mtune=skylake -O3 -fPIC"
export SERPENT_TARGET_CXXFLAGS="${SERPENT_TARGET_CFLAGS}"
