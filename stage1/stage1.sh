#!/usr/bin/env bash

executionPath=$(dirname $(realpath -s $0))

COMPONENTS=(
    "headers"
    "toolchain"
    "musl"
)

prefetchSources

for component in ${COMPONENTS[@]} ; do
    /usr/bin/env -S -i bash --norc --noprofile "${executionPath}/${component}.sh"
done
