cmake_minimum_required(VERSION 4.1.0)

include(CMakePrintHelpers)

if (NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 23)
endif()

set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
# set(CMAKE_CXX_SCAN_FOR_MODULES ON)
set(CMAKE_CXX_MODULE_STD ON)

project("example")

cmake_print_variables(
    CMAKE_CXX_SCAN_FOR_MODULES
    CMAKE_CXX_MODULE_STD 
    CMAKE_CXX_COMPILER_IMPORT_STD)

# cmake_print_variables(CMAKE_CXX_COMPILE_FEATURES)

add_library(main SHARED main.cpp)

# target_compile_features(main PUBLIC cxx_std_23)