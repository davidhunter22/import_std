cmake_minimum_required(VERSION 3.30)


if("${CMAKE_GENERATOR}" STREQUAL "Visual Studio 17 2022")
    # This can be done before or after project() on MSVC
    # It works regardless of CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
    set(CMAKE_CXX_SCAN_FOR_MODULES ON)

    # This does not work on MSVC
    #set(CMAKE_CXX_MODULE_STD ON)
else()
    # Enables the Standard module support. This needs to be done before selecting the languages so the project() command
    set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
    set(CMAKE_CXX_MODULE_STD ON)

	# Does not work reguardless of value of CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
    # set(CMAKE_CXX_SCAN_FOR_MODULES ON)
endif()

project("example")

set(CMAKE_CXX_STANDARD 26)

add_executable(main main.cpp)
