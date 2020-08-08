#!/bin/true

export SERPENT_STAGE_NAME="stage2"

. $(dirname $(realpath -s $0))/../base.sh

# Set up stage2 specific requirements

export SERPENT_STAGE1_TREE=`getInstallDir "1"`

if [[ ! -e "${SERPENT_STAGE1_TREE}/usr/bin/clang" ]]; then
    printError "No stage1 compiler found"
    exit 1
fi

export PATH="${SERPENT_STAGE1_TREE}/usr/bin:$PATH"
unset SERPENT_STAGE1_TREE

# Check its the right clang/llvm.
SERPENT_LLVM_TARGET=`llvm-config --host-target`
if [[ $? -ne 0 ]]; then
    printError "Could not run llvm-config"
    exit 1
fi

if [[ "${SERPENT_LLVM_TARGET}" != "${SERPENT_TRIPLET}" ]]; then
    printError "Incorrect LLVM target: ${SERPENT_LLVM_TARGET}"
    exit 1
fi

printInfo "Using clang/llvm target: ${SERPENT_LLVM_TARGET}"

unset SERPENT_LLVM_TARGET

export CC="clang"
export CXX="clang++"

prepareBuild
