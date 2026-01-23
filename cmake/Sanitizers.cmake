# Sanitizers.cmake
# Configures AddressSanitizer and UndefinedBehaviorSanitizer for runtime error detection

# Only enable sanitizers in Debug builds by default
# Can be explicitly enabled for other builds with -DENABLE_ASAN=ON or -DENABLE_UBSAN=ON
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    option(ENABLE_ASAN "Enable AddressSanitizer (ASan)" ON)
    option(ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer (UBSan)" ON)
else()
    option(ENABLE_ASAN "Enable AddressSanitizer (ASan)" OFF)
    option(ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer (UBSan)" OFF)
endif()

# Enable sanitizers if requested
if(ENABLE_ASAN OR ENABLE_UBSAN)
    set(SANITIZERS_ENABLED FALSE)
    set(SANITIZER_FLAGS "")
    set(SANITIZER_LINK_FLAGS "")

    # Check if compiler supports sanitizers
    include(CheckCXXCompilerFlag)
    
    if(ENABLE_ASAN)
        # Need to set CMAKE_REQUIRED_FLAGS for the check to work properly
        set(CMAKE_REQUIRED_FLAGS "-fsanitize=address")
        check_cxx_compiler_flag("-fsanitize=address" COMPILER_SUPPORTS_ASAN)
        set(CMAKE_REQUIRED_FLAGS "")
        
        if(COMPILER_SUPPORTS_ASAN)
            list(APPEND SANITIZER_FLAGS "-fsanitize=address")
            list(APPEND SANITIZER_LINK_FLAGS "-fsanitize=address")
            set(SANITIZERS_ENABLED TRUE)
            message(STATUS "AddressSanitizer (ASan) enabled")
        else()
            message(FATAL_ERROR 
                "AddressSanitizer not supported by compiler. "
                "Requires GCC 4.8+ or Clang 3.1+. "
                "Current compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
        endif()
    endif()

    if(ENABLE_UBSAN)
        # Need to set CMAKE_REQUIRED_FLAGS for the check to work properly
        set(CMAKE_REQUIRED_FLAGS "-fsanitize=undefined")
        check_cxx_compiler_flag("-fsanitize=undefined" COMPILER_SUPPORTS_UBSAN)
        set(CMAKE_REQUIRED_FLAGS "")
        
        if(COMPILER_SUPPORTS_UBSAN)
            list(APPEND SANITIZER_FLAGS "-fsanitize=undefined")
            list(APPEND SANITIZER_LINK_FLAGS "-fsanitize=undefined")
            set(SANITIZERS_ENABLED TRUE)
            message(STATUS "UndefinedBehaviorSanitizer (UBSan) enabled")
        else()
            message(FATAL_ERROR 
                "UndefinedBehaviorSanitizer not supported by compiler. "
                "Requires GCC 4.9+ or Clang 3.3+. "
                "Current compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
        endif()
    endif()

    if(SANITIZERS_ENABLED)
        # Add common flags for better stack traces
        list(APPEND SANITIZER_FLAGS 
            "-fno-omit-frame-pointer"
            "-fno-optimize-sibling-calls"
        )
        
        # Join flags into strings
        string(REPLACE ";" " " SANITIZER_FLAGS_STR "${SANITIZER_FLAGS}")
        string(REPLACE ";" " " SANITIZER_LINK_FLAGS_STR "${SANITIZER_LINK_FLAGS}")
        
        message(STATUS "Sanitizer compile flags: ${SANITIZER_FLAGS_STR}")
        message(STATUS "Sanitizer link flags: ${SANITIZER_LINK_FLAGS_STR}")
        
        # Print runtime environment hints
        message(STATUS "")
        message(STATUS "=== Sanitizer Runtime Configuration ===")
        message(STATUS "Set these environment variables when running the application:")
        message(STATUS "  export ASAN_OPTIONS=detect_leaks=1:check_initialization_order=1:strict_init_order=1")
        message(STATUS "  export UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1")
        message(STATUS "=======================================")
        message(STATUS "")
    endif()

    # Function to apply sanitizers to a specific target
    function(enable_sanitizers target_name)
        if(SANITIZERS_ENABLED)
            target_compile_options(${target_name} PRIVATE ${SANITIZER_FLAGS})
            target_link_options(${target_name} PRIVATE ${SANITIZER_LINK_FLAGS})
        endif()
    endfunction()

    # Function to apply sanitizers globally
    function(enable_sanitizers_globally)
        if(SANITIZERS_ENABLED)
            add_compile_options(${SANITIZER_FLAGS})
            add_link_options(${SANITIZER_LINK_FLAGS})
            message(STATUS "Sanitizers applied globally to all targets")
        endif()
    endfunction()
else()
    message(STATUS "Sanitizers disabled (Build type: ${CMAKE_BUILD_TYPE}, ENABLE_ASAN=${ENABLE_ASAN}, ENABLE_UBSAN=${ENABLE_UBSAN})")
    message(STATUS "To enable sanitizers in Release builds, use: cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_ASAN=ON ..")
    
    # Provide empty functions when sanitizers are disabled
    function(enable_sanitizers target_name)
        # No-op
    endfunction()
    
    function(enable_sanitizers_globally)
        # No-op
    endfunction()
endif()

