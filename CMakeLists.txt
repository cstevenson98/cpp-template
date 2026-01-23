cmake_minimum_required(VERSION 4.0.0)
project(CppTemplate VERSION 1.0.0 LANGUAGES CXX)

# ============================================================================
# C++23 Standard Configuration
# ============================================================================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ============================================================================
# Project tooling configuration
# ============================================================================
include(cmake/CompilerWarnings.cmake)
include(cmake/ClangTidy.cmake)
include(cmake/ClangFormat.cmake)
include(cmake/Sanitizers.cmake)

# ============================================================================
# Dependencies
# ============================================================================
include(cmake/Dependencies.cmake)

# ============================================================================
# Apply tooling globally to all our targets (but not third-party dependencies)
# ============================================================================
set_project_warnings_globally()
enable_clang_tidy_globally()
enable_clang_format_globally()
enable_sanitizers_globally()

# ============================================================================
# Library: mylib (example static library)
# ============================================================================
add_subdirectory(mylib)

# ============================================================================
# Main executable
# ============================================================================
add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_include_directories(${PROJECT_NAME} PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    mylib
)

# ============================================================================
# Testing
# ============================================================================
enable_testing()
add_subdirectory(tests)

# ============================================================================
# Installation rules (optional)
# ============================================================================
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

install(TARGETS mylib
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

install(DIRECTORY mylib/include/
    DESTINATION include
)

