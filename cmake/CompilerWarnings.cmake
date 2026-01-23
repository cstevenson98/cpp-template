# CompilerWarnings.cmake
# Sets strict compiler warnings for the project

option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)

# Function to apply warnings to a specific target
function(set_project_warnings target_name)
    set(MSVC_WARNINGS
        /W4     # Baseline reasonable warnings
        /w14242 # 'identifier': conversion from 'type1' to 'type2', possible loss of data
        /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
        /w14263 # 'function': member function does not override any base class virtual member function
        /w14265 # 'classname': class has virtual functions, but destructor is not virtual
        /w14287 # 'operator': unsigned/negative constant mismatch
        /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
        /w14296 # 'operator': expression is always 'boolean_value'
        /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
        /w14545 # expression before comma evaluates to a function which is missing an argument list
        /w14546 # function call before comma missing argument list
        /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
        /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
        /w14555 # expression has no effect; expected expression with side-effect
        /w14619 # pragma warning: there is no warning number 'number'
        /w14640 # Enable warning on thread un-safe static member initialization
        /w14826 # Conversion from 'type1' to 'type2' is sign-extended. This may cause unexpected runtime behavior.
        /w14905 # wide string literal cast to 'LPSTR'
        /w14906 # string literal cast to 'LPWSTR'
        /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
        /permissive- # standards conformance mode for MSVC compiler.
    )

    # Common warnings supported by both GCC and Clang
    set(CLANG_WARNINGS
        -Wall
        -Wextra
        -Wshadow
        -Wnon-virtual-dtor
        -Wcast-align
        -Wunused
        -Woverloaded-virtual
        -Wpedantic
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2
        -Wmisleading-indentation
    )

    set(GCC_WARNINGS
        ${CLANG_WARNINGS}
    )

    if(WARNINGS_AS_ERRORS)
        set(CLANG_WARNINGS ${CLANG_WARNINGS} -Werror)
        set(GCC_WARNINGS ${GCC_WARNINGS} -Werror)
        set(MSVC_WARNINGS ${MSVC_WARNINGS} /WX)
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(PROJECT_WARNINGS ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(PROJECT_WARNINGS ${GCC_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(PROJECT_WARNINGS ${MSVC_WARNINGS})
    else()
        message(AUTHOR_WARNING "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()

    target_compile_options(${target_name} PRIVATE ${PROJECT_WARNINGS})
endfunction()

# Apply warnings globally to all targets created after this point
function(set_project_warnings_globally)
    set(MSVC_WARNINGS
        /W4 /w14242 /w14254 /w14263 /w14265 /w14287 /we4289 /w14296 
        /w14311 /w14545 /w14546 /w14547 /w14549 /w14555 /w14619 /w14640 
        /w14826 /w14905 /w14906 /w14928 /permissive-
    )

    # Common warnings supported by both GCC and Clang
    set(CLANG_WARNINGS
        -Wall -Wextra -Wshadow -Wnon-virtual-dtor -Wcast-align
        -Wunused -Woverloaded-virtual -Wpedantic
        -Wnull-dereference -Wdouble-promotion -Wformat=2
        -Wmisleading-indentation
    )

    set(GCC_WARNINGS
        ${CLANG_WARNINGS}
    )

    if(WARNINGS_AS_ERRORS)
        set(CLANG_WARNINGS ${CLANG_WARNINGS} -Werror)
        set(GCC_WARNINGS ${GCC_WARNINGS} -Werror)
        set(MSVC_WARNINGS ${MSVC_WARNINGS} /WX)
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(PROJECT_WARNINGS ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(PROJECT_WARNINGS ${GCC_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(PROJECT_WARNINGS ${MSVC_WARNINGS})
    endif()

    # Apply globally
    add_compile_options(${PROJECT_WARNINGS})
    message(STATUS "Compiler warnings applied globally to all targets")
endfunction()

