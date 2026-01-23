# ============================================================================
# ClangFormat.cmake
# Provides targets for formatting C++ code with clang-format
# ============================================================================

# Find clang-format executable
find_program(CLANG_FORMAT_EXECUTABLE
    NAMES clang-format clang-format-19
    DOC "Path to clang-format executable"
)

if(CLANG_FORMAT_EXECUTABLE)
    execute_process(
        COMMAND ${CLANG_FORMAT_EXECUTABLE} --version
        OUTPUT_VARIABLE CLANG_FORMAT_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "Found clang-format: ${CLANG_FORMAT_EXECUTABLE}")
    message(STATUS "clang-format version: ${CLANG_FORMAT_VERSION}")
else()
    message(WARNING "clang-format not found. Format targets will not be available.")
endif()

# ============================================================================
# Function: add_clang_format_target
# Creates clang-format targets for a specific list of files
# ============================================================================
function(add_clang_format_target TARGET_NAME)
    if(NOT CLANG_FORMAT_EXECUTABLE)
        return()
    endif()

    cmake_parse_arguments(ARG "" "" "SOURCES" ${ARGN})
    
    if(NOT ARG_SOURCES)
        message(WARNING "add_clang_format_target called without SOURCES")
        return()
    endif()

    # Create a target to check formatting
    add_custom_target(${TARGET_NAME}-format-check
        COMMAND ${CLANG_FORMAT_EXECUTABLE}
            --dry-run
            --Werror
            --style=file
            ${ARG_SOURCES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Checking code formatting for ${TARGET_NAME}"
        VERBATIM
    )

    # Create a target to fix formatting
    add_custom_target(${TARGET_NAME}-format-fix
        COMMAND ${CLANG_FORMAT_EXECUTABLE}
            -i
            --style=file
            ${ARG_SOURCES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Fixing code formatting for ${TARGET_NAME}"
        VERBATIM
    )
endfunction()

# ============================================================================
# Function: enable_clang_format_for_target
# Enables clang-format for a specific target's sources
# ============================================================================
function(enable_clang_format_for_target TARGET_NAME)
    if(NOT CLANG_FORMAT_EXECUTABLE)
        return()
    endif()

    # Get the target's source files
    get_target_property(TARGET_SOURCES ${TARGET_NAME} SOURCES)
    
    if(NOT TARGET_SOURCES)
        message(WARNING "Target ${TARGET_NAME} has no sources")
        return()
    endif()

    # Filter to only C++ source files
    set(FORMAT_SOURCES "")
    foreach(SOURCE ${TARGET_SOURCES})
        # Make path absolute if it's relative
        if(NOT IS_ABSOLUTE ${SOURCE})
            get_target_property(SOURCE_DIR ${TARGET_NAME} SOURCE_DIR)
            set(SOURCE "${SOURCE_DIR}/${SOURCE}")
        endif()
        
        # Only add C++ files
        if(SOURCE MATCHES "\\.(cpp|hpp|h|cc|cxx|hxx)$")
            list(APPEND FORMAT_SOURCES ${SOURCE})
        endif()
    endforeach()

    if(FORMAT_SOURCES)
        add_clang_format_target(${TARGET_NAME} SOURCES ${FORMAT_SOURCES})
    endif()
endfunction()

# ============================================================================
# Function: enable_clang_format_globally
# Creates global format targets for all project sources
# ============================================================================
function(enable_clang_format_globally)
    if(NOT CLANG_FORMAT_EXECUTABLE)
        return()
    endif()

    # Collect all C++ source files in the project
    file(GLOB_RECURSE ALL_SOURCE_FILES
        "${CMAKE_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_SOURCE_DIR}/src/*.hpp"
        "${CMAKE_SOURCE_DIR}/src/*.h"
        "${CMAKE_SOURCE_DIR}/mylib/**/*.cpp"
        "${CMAKE_SOURCE_DIR}/mylib/**/*.hpp"
        "${CMAKE_SOURCE_DIR}/mylib/**/*.h"
        "${CMAKE_SOURCE_DIR}/tests/*.cpp"
        "${CMAKE_SOURCE_DIR}/tests/*.hpp"
        "${CMAKE_SOURCE_DIR}/tests/*.h"
    )
    
    # Filter out build directory and third-party code
    list(FILTER ALL_SOURCE_FILES EXCLUDE REGEX "${CMAKE_BINARY_DIR}/.*")
    list(FILTER ALL_SOURCE_FILES EXCLUDE REGEX ".*/build/.*")
    list(FILTER ALL_SOURCE_FILES EXCLUDE REGEX ".*/_deps/.*")

    if(ALL_SOURCE_FILES)
        list(LENGTH ALL_SOURCE_FILES NUM_SOURCE_FILES)
        message(STATUS "Enabling clang-format for ${CMAKE_PROJECT_NAME}")
        message(STATUS "  Found ${NUM_SOURCE_FILES} source files to format")
        
        # Create global format-check target
        add_custom_target(format-check
            COMMAND ${CLANG_FORMAT_EXECUTABLE}
                --dry-run
                --Werror
                --style=file
                ${ALL_SOURCE_FILES}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Checking code formatting for entire project"
            VERBATIM
        )

        # Create global format-fix target
        add_custom_target(format-fix
            COMMAND ${CLANG_FORMAT_EXECUTABLE}
                -i
                --style=file
                ${ALL_SOURCE_FILES}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Fixing code formatting for entire project"
            VERBATIM
        )
        
        # Create alias 'format' that runs format-fix
        add_custom_target(format
            DEPENDS format-fix
        )

        message(STATUS "clang-format targets created:")
        message(STATUS "  - format-check: Check formatting without modifying files")
        message(STATUS "  - format-fix (or 'format'): Automatically fix formatting")
    else()
        message(WARNING "No source files found for clang-format")
    endif()
endfunction()

