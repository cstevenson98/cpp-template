# ClangTidy.cmake
# Integrates clang-tidy static analysis into the build system

option(ENABLE_CLANG_TIDY "Enable clang-tidy static analysis" ON)

if(ENABLE_CLANG_TIDY)
    # Find clang-tidy executable
    find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
    
    if(NOT CLANG_TIDY_EXE)
        message(FATAL_ERROR 
            "clang-tidy is required but not found. "
            "Install with:\n"
            "  Ubuntu/Debian: sudo apt-get install clang-tidy\n"
            "  Fedora/RHEL:   sudo dnf install clang-tools-extra\n"
            "  macOS:         brew install llvm\n"
            "After installation, ensure clang-tidy is in your PATH.")
    endif()

    # Get clang-tidy version
    execute_process(
        COMMAND ${CLANG_TIDY_EXE} --version
        OUTPUT_VARIABLE CLANG_TIDY_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    
    message(STATUS "Found clang-tidy: ${CLANG_TIDY_EXE}")
    message(STATUS "clang-tidy version: ${CLANG_TIDY_VERSION}")

    # Set the clang-tidy command with options
    set(CLANG_TIDY_COMMAND 
        "${CLANG_TIDY_EXE}"
        "--warnings-as-errors=*"
        "--use-color"
    )

    # Apply clang-tidy to a specific target
    function(enable_clang_tidy target_name)
        set_target_properties(${target_name} PROPERTIES
            CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}"
        )
        message(STATUS "clang-tidy enabled for target: ${target_name}")
    endfunction()

    # Apply clang-tidy globally to all targets
    function(enable_clang_tidy_globally)
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}" PARENT_SCOPE)
        message(STATUS "clang-tidy integration enabled globally")
    endfunction()

    message(STATUS "clang-tidy integration enabled")
else()
    message(STATUS "clang-tidy integration disabled")
    
    # Provide empty functions when clang-tidy is disabled
    function(enable_clang_tidy target_name)
        # No-op
    endfunction()
    
    function(enable_clang_tidy_globally)
        # No-op
    endfunction()
endif()

