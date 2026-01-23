cmake_minimum_required(VERSION 4.0.0)

# Test executable
add_executable(test_calculator
    test_calculator.cpp
)

target_link_libraries(test_calculator PRIVATE
    mylib
    GTest::gtest
    GTest::gtest_main
)

# Enable testing
include(GoogleTest)
gtest_discover_tests(test_calculator)

