#!/bin/bash
set -e

echo "==================================="
echo "Setting up C++23 Development Environment"
echo "==================================="

# Configure git if not already configured
echo ""
echo "Configuring git..."
if ! git config --global user.name > /dev/null 2>&1; then
    echo "Git user.name not set. Please configure git:"
    echo "  git config --global user.name 'Your Name'"
    echo "  git config --global user.email 'your.email@example.com'"
else
    echo "✓ Git already configured:"
    echo "  User: $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
fi

# Install oh-my-zsh
echo ""
echo "Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✓ oh-my-zsh installed successfully!"
else
    echo "✓ oh-my-zsh already installed"
fi

# Restore the version info to .zshrc (oh-my-zsh installation may have overwritten it)
cat >> ~/.zshrc << 'EOF'

# Development environment info
echo "=== C++23 Development Environment ==="
echo "Clang: $(clang++ --version 2>/dev/null | head -n1 || echo "Not found")"
echo "CMake: $(cmake --version 2>/dev/null | head -n1 || echo "Not found")"
echo "clang-tidy: $(clang-tidy --version 2>/dev/null | head -n1 || echo "Not found")"
echo "====================================="
EOF

# Display tool versions
echo ""
echo "Installed Tools:"
echo "  Clang: $(clang++ --version | head -n1)"
echo "  CMake: $(cmake --version | head -n1)"
echo "  clang-tidy: $(clang-tidy --version | head -n1)"
echo ""

# Test C++23 std::expected availability
echo "Testing C++23 std::expected availability..."
cat > /tmp/test_expected.cpp << 'EOF'
#include <expected>
#include <iostream>
#include <string>

auto test_expected() -> std::expected<int, std::string> {
    return 42;
}

int main() {
    auto result = test_expected();
    if (result.has_value()) {
        std::cout << "✓ std::expected is available and working!" << std::endl;
        std::cout << "  Value: " << result.value() << std::endl;
        return 0;
    }
    std::cerr << "✗ std::expected test failed" << std::endl;
    return 1;
}
EOF

# Compile and run the test
if clang++-19 -std=c++23 -stdlib=libc++ /tmp/test_expected.cpp -o /tmp/test_expected 2>/dev/null; then
    if /tmp/test_expected; then
        echo "✓ C++23 std::expected verification passed!"
    else
        echo "✗ C++23 std::expected test execution failed"
        exit 1
    fi
else
    echo "✗ Failed to compile C++23 std::expected test"
    exit 1
fi

# Clean up test files
rm -f /tmp/test_expected.cpp /tmp/test_expected

echo ""
echo "==================================="
echo "Building project..."
echo "==================================="

# Configure and build the project
if [ -f "CMakeLists.txt" ]; then
    cmake -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang-19 -DCMAKE_CXX_COMPILER=clang++-19
    cmake --build build
    
    echo ""
    echo "Running tests..."
    cd build && ctest --output-on-failure && cd ..
    
    echo ""
    echo "✓ Project built and tested successfully!"
else
    echo "⚠ CMakeLists.txt not found, skipping build"
fi

echo ""
echo "==================================="
echo "Environment Ready!"
echo "==================================="
echo ""
echo "Quick Start:"
echo "  1. Build project:  cmake -B build && cmake --build build"
echo "  2. Run tests:      cd build && ctest --output-on-failure"
echo "  3. Run app:        ./build/CppTemplate"
echo ""
echo "Sanitizers are enabled in Debug builds!"
echo "Set environment variables for better output:"
echo "  export ASAN_OPTIONS=detect_leaks=1:check_initialization_order=1"
echo "  export UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1"
echo ""

