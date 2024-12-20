# First, define the function to get IVSHMEM info
function(find_ivshmem_info ADDR_OUT SIZE_OUT)
    execute_process(
        COMMAND bash -c "lspci -vvv | grep -A 10 'Inter-VM shared memory' | grep 'Region 2'"
        OUTPUT_VARIABLE IVSHMEM_INFO
        RESULT_VARIABLE RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(NOT RESULT EQUAL 0)
        message(FATAL_ERROR "Failed to find Inter-VM shared memory device")
    endif()

    # Extract address
    if(NOT ${IVSHMEM_INFO} MATCHES "Memory at ([0-9a-fA-F]+)")
        message(FATAL_ERROR "Failed to extract memory address from: ${IVSHMEM_INFO}")
    endif()
    set(ADDR_HEX "0x${CMAKE_MATCH_1}")
    
    # Extract size
    if(NOT ${IVSHMEM_INFO} MATCHES "size=([0-9]+)M")
        message(FATAL_ERROR "Failed to extract memory size from: ${IVSHMEM_INFO}")
    endif()
    set(SIZE_M ${CMAKE_MATCH_1})
    
    # Convert size to bytes
    math(EXPR SIZE_BYTES "${SIZE_M} * 1024 * 1024")
    
    # Set output variables
    set(${ADDR_OUT} ${ADDR_HEX} PARENT_SCOPE)
    set(${SIZE_OUT} ${SIZE_BYTES} PARENT_SCOPE)
endfunction()
