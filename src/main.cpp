/**
 * @file main.cpp
 * @brief Main entry point for the application
 */

#include "mylib/Calculator.hpp"

#include <format>
#include <iostream>

auto main() -> int {
    using mylib::Calculator;

    std::cout << std::format("Calculator Demo - C++23 Template\n");
    std::cout << std::format("================================\n");

    // Sanitizers are active (they only report when errors are detected)
#ifdef __has_feature
    #if __has_feature(address_sanitizer)
    std::cout << std::format("✓ AddressSanitizer: ENABLED\n");
    #endif
    #if __has_feature(undefined_behavior_sanitizer)
    std::cout << std::format("✓ UndefinedBehaviorSanitizer: ENABLED\n");
    #endif
#endif
    std::cout << std::format("\n");

    // Basic operations
    const double a = 10.0;
    const double b = 3.0;

    std::cout << std::format("a = {}, b = {}\n\n", a, b);
    std::cout << std::format("Addition: {} + {} = {}\n", a, b, Calculator::add(a, b));
    std::cout << std::format("Subtraction: {} - {} = {}\n", a, b, Calculator::subtract(a, b));
    std::cout << std::format("Multiplication: {} * {} = {}\n", a, b, Calculator::multiply(a, b));

    // Division with std::expected error handling
    if (auto result = Calculator::divide(a, b); result.has_value()) {
        std::cout << std::format("Division: {} / {} = {}\n", a, b, result.value());
    } else {
        std::cout << std::format("Division error: {}\n", Calculator::errorToString(result.error()));
    }

    // Test division by zero
    std::cout << std::format("\nTesting division by zero:\n");
    const double zero = 0.0;
    if (auto result = Calculator::divide(a, zero); result.has_value()) {
        std::cout << std::format("Division: {} / {} = {}\n", a, zero, result.value());
    } else {
        std::cout << std::format("Division error: {}\n", Calculator::errorToString(result.error()));
    }

    return 0;
}
