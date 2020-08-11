#!/bin/true

export SERPENT_STAGE_NAME="stage1"

. $(dirname $(realpath -s $0))/../lib/build.sh

# Set up stage1 specific requirements

if [[ `which gcc 2>/dev/null` ]]; then
    export CC="gcc"
    export CXX="g++"
else
    printError "No usable compiler was found"
    exit 1
fi

prepareBuild
