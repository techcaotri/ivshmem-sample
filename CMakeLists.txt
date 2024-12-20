cmake_minimum_required(VERSION 3.10)
project(ivshmem-sample)

include(${CMAKE_SOURCE_DIR}/cmake/config/ivshmem_config.cmake)
# Get IVSHMEM information
find_ivshmem_info(IVSHMEM_ADDR IVSHMEM_SIZE)
message("IVSHMEM Address: ${IVSHMEM_ADDR}")
message("IVSHMEM Size in bytes: ${IVSHMEM_SIZE}")

# Generate configuration file
configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/config/ivshmem_config.h.in"
    "${CMAKE_SOURCE_DIR}/include/ivshmem_config.h"
)

include_directories(${CMAKE_SOURCE_DIR}/include)
add_executable(ivshmem_read_write ivshmem_read_write.c)
