# ============================================================================
# Dependencies.cmake
# Manages external dependencies using CMake's FetchContent
# ============================================================================

include(FetchContent)

# ============================================================================
# How to Add a New Library:
# ============================================================================
# 1. Use FetchContent_Declare to specify the library source
# 2. Call FetchContent_MakeAvailable to download and configure it
# 3. Mark it as SYSTEM to suppress warnings from third-party code
# 4. Link it to your target in your CMakeLists.txt
#
# Example:
#   FetchContent_Declare(
#       libraryname
#       GIT_REPOSITORY https://github.com/user/library.git
#       GIT_TAG        v1.0.0
#       GIT_SHALLOW    TRUE  # Faster clone, only gets specified tag
#   )
#   FetchContent_MakeAvailable(libraryname)
#
# Then in your target:
#   target_link_libraries(YourTarget PRIVATE libraryname)
# ============================================================================

# ============================================================================
# GoogleTest - Unit Testing Framework
# ============================================================================
# Documentation: https://google.github.io/googletest/
message(STATUS "Fetching GoogleTest...")

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        v1.15.2
    GIT_SHALLOW    TRUE
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Download and make available
FetchContent_MakeAvailable(googletest)

# Mark third-party libraries as SYSTEM to suppress warnings from their headers
set_target_properties(gtest PROPERTIES 
    INTERFACE_SYSTEM_INCLUDE_DIRECTORIES $<TARGET_PROPERTY:gtest,INTERFACE_INCLUDE_DIRECTORIES>
)
set_target_properties(gtest_main PROPERTIES 
    INTERFACE_SYSTEM_INCLUDE_DIRECTORIES $<TARGET_PROPERTY:gtest_main,INTERFACE_INCLUDE_DIRECTORIES>
)
set_target_properties(gmock PROPERTIES 
    INTERFACE_SYSTEM_INCLUDE_DIRECTORIES $<TARGET_PROPERTY:gmock,INTERFACE_INCLUDE_DIRECTORIES>
)
set_target_properties(gmock_main PROPERTIES 
    INTERFACE_SYSTEM_INCLUDE_DIRECTORIES $<TARGET_PROPERTY:gmock_main,INTERFACE_INCLUDE_DIRECTORIES>
)

message(STATUS "GoogleTest fetched and configured")

# ============================================================================
# Example: Add more libraries here following the same pattern
# ============================================================================
#
# # fmt - Modern formatting library (alternative to std::format)
# FetchContent_Declare(
#     fmt
#     GIT_REPOSITORY https://github.com/fmtlib/fmt.git
#     GIT_TAG        10.2.1
#     GIT_SHALLOW    TRUE
# )
# FetchContent_MakeAvailable(fmt)
#
# # spdlog - Fast logging library
# FetchContent_Declare(
#     spdlog
#     GIT_REPOSITORY https://github.com/gabime/spdlog.git
#     GIT_TAG        v1.13.0
#     GIT_SHALLOW    TRUE
# )
# FetchContent_MakeAvailable(spdlog)
#
# # JSON for Modern C++
# FetchContent_Declare(
#     nlohmann_json
#     GIT_REPOSITORY https://github.com/nlohmann/json.git
#     GIT_TAG        v3.11.3
#     GIT_SHALLOW    TRUE
# )
# FetchContent_MakeAvailable(nlohmann_json)
#
# # Catch2 - Alternative testing framework
# FetchContent_Declare(
#     Catch2
#     GIT_REPOSITORY https://github.com/catchorg/Catch2.git
#     GIT_TAG        v3.5.2
#     GIT_SHALLOW    TRUE
# )
# FetchContent_MakeAvailable(Catch2)
#
# # CLI11 - Command line parser
# FetchContent_Declare(
#     CLI11
#     GIT_REPOSITORY https://github.com/CLIUtils/CLI11.git
#     GIT_TAG        v2.4.1
#     GIT_SHALLOW    TRUE
# )
# FetchContent_MakeAvailable(CLI11)
#
# # GLFW - OpenGL windowing (for game development)
# FetchContent_Declare(
#     glfw
#     GIT_REPOSITORY https://github.com/glfw/glfw.git
#     GIT_TAG        3.4
#     GIT_SHALLOW    TRUE
# )
# set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
# set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
# set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
# FetchContent_MakeAvailable(glfw)
#
# ============================================================================




