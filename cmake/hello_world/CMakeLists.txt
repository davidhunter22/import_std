cmake_minimum_required(VERSION 4.1.0)

include(CMakePrintHelpers)

if (NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 23)
endif()

# You don't need to do anything on Visual Studio
if( NOT ${CMAKE_GENERATOR} MATCHES "Visual Studio*" )
    message(STATUS "Setting CMAKE_CXX_MODULE_STD")
    set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
    set(CMAKE_CXX_MODULE_STD ON)
endif()

project("example")

cmake_print_variables(
    CMAKE_CXX_FLAGS
    CMAKE_CXX_MODULE_STD 
    CMAKE_CXX_COMPILER_IMPORT_STD)

add_executable(main main.cpp)
