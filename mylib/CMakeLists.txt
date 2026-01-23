cmake_minimum_required(VERSION 4.0.0)
project(MyLib VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Collect all source files
file(GLOB_RECURSE MYLIB_SOURCES "src/*.cpp")
file(GLOB_RECURSE MYLIB_HEADERS "include/mylib/*.hpp")

# Create static library
add_library(mylib STATIC ${MYLIB_SOURCES} ${MYLIB_HEADERS})

# Public include directory
target_include_directories(mylib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Export library
set(MYLIB_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include PARENT_SCOPE)

