#!/usr/bin/env bash

export SERPENT_STAGE_NAME="stage2"

. $(dirname $(realpath -s $0))/../base.sh

executionPath=$(dirname $(realpath -s $0))

COMPONENTS=(
    "root"
    "headers"
    "musl"
    "ncurses"
)

prefetchSources

for component in ${COMPONENTS[@]} ; do
    /usr/bin/env -S -i bash --norc --noprofile "${executionPath}/${component}.sh"
done
