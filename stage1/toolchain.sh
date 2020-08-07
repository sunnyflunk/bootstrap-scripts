#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

export TOOLCHAIN_VERSION="10.0.1"

printInfo "Extracting toolchain requirements"
extractSource clang
extractSource compiler-rt
extractSource libcxx
extractSource libcxxabi
extractSource libunwind
extractSource lld
extractSource llvm
extractSource openmp
extractSource polly


ln -sv "clang-${TOOLCHAIN_VERSION}.src" clang
ln -sv "compiler-rt-${TOOLCHAIN_VERSION}.src" compiler-rt
ln -sv "libcxx-${TOOLCHAIN_VERSION}.src" libcxx
ln -sv "libcxxabi-${TOOLCHAIN_VERSION}.src" libcxxabi
ln -sv "libunwind-${TOOLCHAIN_VERSION}.src" libunwind
ln -sv "lld-${TOOLCHAIN_VERSION}.src" lld
ln -sv "llvm-${TOOLCHAIN_VERSION}.src" llvm
ln -sv "openmp-${TOOLCHAIN_VERSION}.src" openmp
ln -sv "polly-${TOOLCHAIN_VERSION}.src" polly

pushd llvm

mkdir build && pushd build
cmake -G Ninja ../ \
    -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;libcxx;libcxxabi;libunwind;lld;llvm;openmp;polly' \
    -DDEFAULT_SYSROOT="${SERPENT_INSTALL_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGET_ARCH="${SERPENT_ARCH}" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="${SERPENT_TRIPLET}" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_INCLUDE_TESTS=OFF

ninja -j ${SERPENT_BUILD_JOBS} -v
