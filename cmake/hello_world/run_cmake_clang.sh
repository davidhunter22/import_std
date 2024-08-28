#!/bin/sh

cmake -G Ninja -DCMAKE_CXX_FLAGS=-stdlib=libc++ -DCMAKE_CXX_COMPILER=/usr/lib/llvm-20/bin/clang++ ../../src

# cmake --trace-expand --trace-redirect=trace_expand.txt -G Ninja -DCMAKE_CXX_FLAGS=-stdlib=libc++ -DCMAKE_CXX_COMPILER=/usr/lib/llvm-20/bin/clang++ -DCMAKE_C_COMPILER=/usr/lib/llvm-20/bin/clang ../../src
