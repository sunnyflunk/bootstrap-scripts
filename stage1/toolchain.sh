#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

extractSource clang
extractSource compiler-rt
extractSource libcxx
extractSource libcxxabi
extractSource libunwind
extractSource lld
extractSource llvm
extractSource openmp
extractSource polly

