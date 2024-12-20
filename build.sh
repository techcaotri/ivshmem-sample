#!/bin/bash -x

# CMAKE_C_COMPILER="-DCMAKE_C_COMPILER=/usr/bin/gcc-11"
# CMAKE_CXX_COMPILER="-DCMAKE_CXX_COMPILER=/usr/bin/g++-11"

# DEBUG_FIND="--debug-find"

cmake \
  "${DEBUG_FIND:-}" \
  -B build -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  . 2>&1 | tee cmake.log
cmake --build build --parallel $(($(nproc)-2)) --verbose 2>&1 | tee build.log

