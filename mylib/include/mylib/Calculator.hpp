/**
 * @file Calculator.hpp
 * @brief A simple calculator class demonstrating C++23 features
 * @author Your Name
 * @date 2026
 */

#pragma once

#include <cstdint>
#include <expected>
#include <string>

namespace mylib {

/**
 * @brief Error codes for calculator operations
 */
enum class CalculatorError : std::uint8_t {
    DivisionByZero,   ///< Attempted division by zero
    InvalidOperation  ///< Invalid mathematical operation
};

/**
 * @brief A simple calculator class demonstrating std::expected for error handling
 *
 * This class provides basic arithmetic operations using C++23's std::expected
 * for elegant error handling without exceptions.
 */
class Calculator {
  public:
    /**
     * @brief Adds two numbers
     * @param a First operand
     * @param b Second operand
     * @return The sum of a and b
     */
    [[nodiscard]] static auto add(double a, double b) -> double;

    /**
     * @brief Subtracts b from a
     * @param a First operand
     * @param b Second operand
     * @return The difference of a and b
     */
    [[nodiscard]] static auto subtract(double a, double b) -> double;

    /**
     * @brief Multiplies two numbers
     * @param a First operand
     * @param b Second operand
     * @return The product of a and b
     */
    [[nodiscard]] static auto multiply(double a, double b) -> double;

    /**
     * @brief Divides a by b
     * @param a Numerator
     * @param b Denominator
     * @return Expected containing the quotient, or CalculatorError on failure
     */
    [[nodiscard]] static auto divide(double a, double b) -> std::expected<double, CalculatorError>;

    /**
     * @brief Converts error code to human-readable string
     * @param error The error code
     * @return String description of the error
     */
    [[nodiscard]] static auto errorToString(CalculatorError error) -> std::string;
};

}  // namespace mylib
