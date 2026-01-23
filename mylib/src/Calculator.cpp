/**
 * @file Calculator.cpp
 * @brief Implementation of the Calculator class
 */

#include "mylib/Calculator.hpp"

#include <cmath>
#include <limits>

namespace mylib {

auto Calculator::add(double a, double b) -> double {
    return a + b;
}

auto Calculator::subtract(double a, double b) -> double {
    return a - b;
}

auto Calculator::multiply(double a, double b) -> double {
    return a * b;
}

auto Calculator::divide(double a, double b) -> std::expected<double, CalculatorError> {
    // Check for division by zero with epsilon comparison
    constexpr double epsilon = std::numeric_limits<double>::epsilon();
    if (std::abs(b) < epsilon) {
        return std::unexpected(CalculatorError::DivisionByZero);
    }

    return a / b;
}

auto Calculator::errorToString(CalculatorError error) -> std::string {
    switch (error) {
        case CalculatorError::DivisionByZero:
            return "Division by zero error";
        case CalculatorError::InvalidOperation:
            return "Invalid operation error";
        default:
            return "Unknown error";
    }
}

}  // namespace mylib
