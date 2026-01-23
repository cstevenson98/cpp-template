/**
 * @file test_calculator.cpp
 * @brief Unit tests for the Calculator class using GoogleTest
 */

#include "mylib/Calculator.hpp"

#include <cmath>
#include <limits>

#include <gtest/gtest.h>

using mylib::Calculator;
using mylib::CalculatorError;

namespace {

/**
 * @brief Test fixture for Calculator tests
 */
class CalculatorTest : public ::testing::Test {
  protected:
    static constexpr double EPSILON = std::numeric_limits<double>::epsilon() * 100;

    /**
     * @brief Helper to compare floating point numbers
     */
    static auto areClose(double a, double b) -> bool { return std::abs(a - b) < EPSILON; }
};

} // namespace

// ============================================================================
// Addition Tests
// ============================================================================

TEST_F(CalculatorTest, AddPositiveNumbers) {
    EXPECT_TRUE(areClose(Calculator::add(2.0, 3.0), 5.0));
}

TEST_F(CalculatorTest, AddNegativeNumbers) {
    EXPECT_TRUE(areClose(Calculator::add(-2.0, -3.0), -5.0));
}

TEST_F(CalculatorTest, AddMixedNumbers) {
    EXPECT_TRUE(areClose(Calculator::add(5.0, -3.0), 2.0));
}

// ============================================================================
// Subtraction Tests
// ============================================================================

TEST_F(CalculatorTest, SubtractPositiveNumbers) {
    EXPECT_TRUE(areClose(Calculator::subtract(5.0, 3.0), 2.0));
}

TEST_F(CalculatorTest, SubtractNegativeNumbers) {
    EXPECT_TRUE(areClose(Calculator::subtract(-2.0, -3.0), 1.0));
}

// ============================================================================
// Multiplication Tests
// ============================================================================

TEST_F(CalculatorTest, MultiplyPositiveNumbers) {
    EXPECT_TRUE(areClose(Calculator::multiply(4.0, 3.0), 12.0));
}

TEST_F(CalculatorTest, MultiplyByZero) {
    EXPECT_TRUE(areClose(Calculator::multiply(5.0, 0.0), 0.0));
}

TEST_F(CalculatorTest, MultiplyNegativeNumbers) {
    EXPECT_TRUE(areClose(Calculator::multiply(-4.0, -3.0), 12.0));
}

// ============================================================================
// Division Tests (using std::expected)
// ============================================================================

TEST_F(CalculatorTest, DividePositiveNumbers) {
    auto result = Calculator::divide(10.0, 2.0);
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(areClose(result.value(), 5.0));
}

TEST_F(CalculatorTest, DivideByZero) {
    auto result = Calculator::divide(10.0, 0.0);
    ASSERT_FALSE(result.has_value());
    EXPECT_EQ(result.error(), CalculatorError::DivisionByZero);
}

TEST_F(CalculatorTest, DivideByNearZero) {
    auto result = Calculator::divide(10.0, 1e-20);
    // Should still fail due to epsilon check
    ASSERT_FALSE(result.has_value());
    EXPECT_EQ(result.error(), CalculatorError::DivisionByZero);
}

TEST_F(CalculatorTest, DivideNegativeNumbers) {
    auto result = Calculator::divide(-10.0, -2.0);
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(areClose(result.value(), 5.0));
}

// ============================================================================
// Error Message Tests
// ============================================================================

TEST_F(CalculatorTest, ErrorToStringDivisionByZero) {
    const auto error_msg = Calculator::errorToString(CalculatorError::DivisionByZero);
    EXPECT_FALSE(error_msg.empty());
    EXPECT_NE(error_msg.find("zero"), std::string::npos);
}

TEST_F(CalculatorTest, ErrorToStringInvalidOperation) {
    const auto error_msg = Calculator::errorToString(CalculatorError::InvalidOperation);
    EXPECT_FALSE(error_msg.empty());
    EXPECT_NE(error_msg.find("Invalid"), std::string::npos);
}

/**
 * @brief Demonstrate C++23 std::expected usage in a test
 */
TEST_F(CalculatorTest, ExpectedUsagePattern) {
    // This test demonstrates idiomatic std::expected usage
    auto result = Calculator::divide(100.0, 5.0);

    // Pattern 1: has_value() check
    ASSERT_TRUE(result.has_value());

    // Pattern 2: value() access
    EXPECT_TRUE(areClose(result.value(), 20.0));

    // Pattern 3: Transform with and_then
    auto transformed = result.and_then([](double val) -> std::expected<double, CalculatorError> {
        return Calculator::divide(val, 2.0);
    });

    ASSERT_TRUE(transformed.has_value());
    EXPECT_TRUE(areClose(transformed.value(), 10.0));
}
