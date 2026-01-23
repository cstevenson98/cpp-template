# C++23 Project Template

A modern C++23 project template with comprehensive tooling, testing, and development container support.

## Features

- **C++23 Standard**: Full support for C++23 features including `std::expected`
- **CMake 4.0+**: Modern build system with modular configuration
- **Code Formatting**: Automated clang-format integration with check and fix targets
- **Static Analysis**: Integrated clang-tidy with strict checks
- **Sanitizers**: AddressSanitizer and UndefinedBehaviorSanitizer enabled in Debug builds
- **Compiler Warnings**: Comprehensive warning configuration for GCC, Clang, and MSVC
- **Unit Testing**: Google Test framework with automatic test discovery
- **Dev Container**: Pre-configured development environment with latest Clang
- **Cursor AI Integration**: Coding guidelines in `.cursor/rules/`

## Project Structure

```
cpp-template/
├── .cursor/rules/          # Cursor AI coding guidelines
├── cmake/                  # CMake modules
│   ├── CompilerWarnings.cmake
│   ├── ClangTidy.cmake
│   ├── ClangFormat.cmake
│   ├── Sanitizers.cmake
│   └── Dependencies.cmake  # External dependency management
├── mylib/                  # Example static library
│   ├── include/mylib/     # Public headers
│   └── src/               # Implementation
├── src/                   # Application source
├── tests/                 # Unit tests
├── .clang-format         # Code formatting configuration
├── .clang-tidy           # Static analysis configuration
└── CMakeLists.txt        # Root build configuration
```

## Requirements

- CMake 4.0.0 or higher
- C++23 capable compiler:
  - Clang 17+ (recommended)
  - GCC 13+
  - MSVC 19.34+ (Visual Studio 2022 17.4+)
- clang-format (for code formatting)
- clang-tidy (for static analysis)

## Quick Start

### Using Dev Container (Recommended)

The easiest way to get started is using the dev container with VS Code or Cursor:

1. Install Docker and VS Code with Dev Containers extension
2. Open project in VS Code/Cursor
3. Click "Reopen in Container" when prompted
4. Everything is pre-configured and ready to go!

### Manual Setup

```bash
# Clone or use this template
git clone <repository-url>
cd cpp-template

# Configure (Debug build with sanitizers enabled)
cmake -B build -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build

# Run tests
cd build && ctest --output-on-failure

# Run the application
./build/CppTemplate
```

## Build Types

- **Debug** (default): Development build with sanitizers enabled
  ```bash
  cmake -B build -DCMAKE_BUILD_TYPE=Debug
  ```

- **Release**: Optimized production build
  ```bash
  cmake -B build -DCMAKE_BUILD_TYPE=Release
  ```

## Sanitizers

Sanitizers are automatically enabled in Debug builds:

- **AddressSanitizer (ASan)**: Detects memory errors
- **UndefinedBehaviorSanitizer (UBSan)**: Detects undefined behavior

Set these environment variables for better diagnostics:

```bash
export ASAN_OPTIONS=detect_leaks=1:check_initialization_order=1:strict_init_order=1
export UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1
```

To disable sanitizers:
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_ASAN=OFF -DENABLE_UBSAN=OFF
```

## Code Formatting

The project uses clang-format for consistent code formatting, configured in `.clang-format`.

### Format Commands

```bash
# Check if code is properly formatted (no changes made)
cmake --build build --target format-check

# Automatically fix formatting issues
cmake --build build --target format-fix
# or simply:
cmake --build build --target format
```

The `format-check` target will fail if any files need formatting, making it ideal for CI/CD pipelines.

## Static Analysis

The project uses clang-tidy for static analysis, configured in `.clang-tidy`.

To disable clang-tidy:
```bash
cmake -B build -DENABLE_CLANG_TIDY=OFF
```

## Testing

Tests are written using Google Test and located in the `tests/` directory.

```bash
# Run all tests
cd build && ctest --output-on-failure

# Run with verbose output
cd build && ctest -V

# Run specific test
./build/tests/test_calculator
```

## Compiler Warnings

Strict warnings are enabled by default and treated as errors. This ensures code quality and catches potential issues early.

To disable warnings as errors:
```bash
cmake -B build -DWARNINGS_AS_ERRORS=OFF
```

## Creating a New Library

1. Create directory structure:
   ```bash
   mkdir -p mylib/{include/mylib,src}
   ```

2. Add `mylib/CMakeLists.txt`:
   ```cmake
   add_library(mylib STATIC ${SOURCES})
   target_include_directories(mylib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
   ```

3. Add to root `CMakeLists.txt`:
   ```cmake
   add_subdirectory(mylib)
   ```

## Adding External Dependencies

The project uses CMake's `FetchContent` to manage external dependencies. All dependencies are configured in `cmake/Dependencies.cmake`.

### Adding a New Library

1. **Edit `cmake/Dependencies.cmake`** and add your library:

   ```cmake
   FetchContent_Declare(
       libraryname
       GIT_REPOSITORY https://github.com/user/library.git
       GIT_TAG        v1.0.0
       GIT_SHALLOW    TRUE
   )
   FetchContent_MakeAvailable(libraryname)
   ```

2. **Link the library** in your `CMakeLists.txt`:

   ```cmake
   target_link_libraries(YourTarget PRIVATE libraryname)
   ```

3. **Reconfigure CMake** to download the new dependency:

   ```bash
   cmake -B build
   cmake --build build
   ```

### Popular C++ Libraries Examples

The `Dependencies.cmake` file includes commented examples for:

- **fmt**: Modern formatting library
- **spdlog**: Fast logging library  
- **nlohmann_json**: JSON parsing and serialization
- **Catch2**: Alternative testing framework
- **CLI11**: Command-line argument parsing
- **GLFW**: OpenGL windowing for graphics/games

Simply uncomment the library you need and reconfigure CMake.

### Best Practices

- **Pin versions**: Always specify a `GIT_TAG` for reproducible builds
- **Use `GIT_SHALLOW TRUE`**: Faster downloads, only gets the specified version
- **Suppress third-party warnings**: Mark libraries as `SYSTEM` includes
- **Cache options**: Set library-specific options to disable unnecessary features

Example with options:
```cmake
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(glfw)
```

## C++23 Features Demonstrated

This template demonstrates several C++23 features:

- **`std::expected`**: Modern error handling without exceptions
- **`std::format`**: Type-safe string formatting
- **`auto` return types**: Simplified function signatures
- **`[[nodiscard]]`**: Compiler warnings for ignored return values

## Cursor AI Guidelines

The project includes coding guidelines in `.cursor/rules/`:

- `cpp-standards.md`: C++23 standards and modern C++ practices
- `documentation.md`: Doxygen documentation standards
- `testing.md`: Google Test guidelines
- `project-structure.md`: Directory layout and organization
- `build-system.md`: CMake and build configuration

These guide AI assistants to follow project conventions automatically.

## License

[Your License Here]

## Contributing

Contributions are welcome! Please ensure:

1. Code is properly formatted: `cmake --build build --target format-check`
2. Code passes all tests: `ctest`
3. No compiler warnings
4. clang-tidy checks pass
5. New features include tests
6. Public APIs are documented with Doxygen comments

## Resources

- [C++23 Documentation](https://en.cppreference.com/w/cpp/23)
- [CMake Documentation](https://cmake.org/documentation/)
- [Google Test Documentation](https://google.github.io/googletest/)
- [Clang-Tidy Checks](https://clang.llvm.org/extra/clang-tidy/checks/list.html)

