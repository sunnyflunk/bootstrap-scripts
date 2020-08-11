#!/usr/bin/env bash

export SERPENT_STAGE_NAME="stage1"

. $(dirname $(realpath -s $0))/../lib/build.sh

executionPath=$(dirname $(realpath -s $0))

COMPONENTS=(
    "headers"
    "toolchain"
    "musl"
    "pkgconf"
)

prefetchSources

for component in ${COMPONENTS[@]} ; do
    /usr/bin/env -S -i bash --norc --noprofile "${executionPath}/${component}.sh"
done
