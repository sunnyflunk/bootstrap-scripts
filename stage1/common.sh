#!/bin/true

export SERPENT_STAGE_NAME="stage1"

. $(dirname $(realpath -s $0))/../base.sh

# Set up stage1 specific requirements

if [[ `which clang 2>/dev/null` ]]; then
    export CC="clang"
    export CXX="clang++"
elif [[ `which gcc 2>/dev/null` ]]; then
    export CC="gcc"
    export CXX="g++"
else
    printError "No usable compiler was found"
    exit 1
fi
