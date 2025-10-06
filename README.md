# import_std
Experiments and documentation about using import std

## Living in a mixed `import std;` and `#include` world

## Visual Studio MSVC

See https://devblogs.microsoft.com/cppblog/standard-c20-modules-support-with-msvc-in-visual-studio-2019-version-16-8/
Where it states `/std:c++latest Implies C++ Modules` I believe this now include the newer `/std:c++23preview`
The `Implies` here means that module scanning occurs including `import std;` working

`import std;` only works with C++ language standards of 23 or above although see the c++ 20 standard section.
Being set in the generated MSBuild. This leads to `import std;` working, and all other module stuff.

The upshot is if you create a project in the IDE and set the C++ standard version to 23 or above `import std;` will work by default.
Note you can switch it of in the IDE via the "Scan Sources for Module Dependencies" property.

In the MSBuild XML the `<ScanSourceForModuleDependencies>` property is used to control wether module scanning occurs it defaults to `Yes` 
for C++ standards on or above 23

### CMAKE_CXX_STANDARD
The implication of this is that in CMake all you need to do to get `import std;` to work is to set the C++ standard 
to something greater than 23
```
set(CMAKE_CXX_STANDARD 23)
```
this will lead to
```
<ScanSourceForModuleDependencies>true</ScanSourceForModuleDependencies>
```
in the generated MSBuild
Note that this means you don't need to set `CMAKE_CXX_SCAN_FOR_MODULES` or `CMAKE_EXPERIMENTAL_CXX_IMPORT_STD` in your `CMakeLists.txt` file at all..
So a minimal `CMakeLists.txt` that works for `import std;` is
```
cmake_minimum_required(VERSION 4.1.0)
set(CMAKE_CXX_STANDARD 23)
project("example")
add_executable(main main.cpp)
```
I do not know what the minimum CMake version that works but I think at least a year or so old.

### CXX_SCAN_FOR_MODULES

If you set CXX_SCAN_FOR_MODULES explicitly you do need to set the magic value of `CMAKE_EXPERIMENTAL_CXX_IMPORT_STD` or it will be ignored.

You can set the `CXX_SCAN_FOR_MODULES` explicitly if you want
```
set(CXX_SCAN_FOR_MODULES ON)
```
However that is not necessary as it's effectively implied by `CMAKE_CXX_STANDARD`
You can set it to `OFF`
```
set(CXX_SCAN_FOR_MODULES OFF)
```
Which you may want to do if your not using modules and worried about scanning performance. You still see 

### CMAKE_EXPERIMENTAL_CXX_IMPORT_STD

You do not need to set this at all as setting `CMAKE_CXX_STANDARD` does everything.

// See https://gitlab.kitware.com/cmake/cmake/-/issues?sort=created_date&state=closed&search=ScanSourceForModuleDependencies&first_page_size=20&show=eyJpaWQiOiIyNTgwNiIsImZ1bGxfcGF0aCI6ImNtYWtlL2NtYWtlIiwiaWQiOjUyNjg5Nn0%3D

### <BuildStlModules>



Setting `set(CMAKE_CXX_MODULE_STD ON)` will lead to
```
CMake Error in CMakeLists.txt:
  The "CXX_MODULE_STD" property on the target "main" requires that the
  "__CMAKE::CXX23" target exist, but it was not provided by the toolchain.
  Reason:

    Unsupported generator: Visual Studio 17 2022
```

### Ordering with respect to CMake project() command
It appears there is not any ordering constraint this is unlike other generators.
In particular you can do
```
project("example" LANGUAGES CXX)
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)
```
and it will do what you expect.

### `import std` using C++ 20 

I belive the compiler allows `import standard;` for the C++ standard 20 as a backport however not in the IDE
https://github.com/microsoft/STL/issues/3945

To compile main.cpp on the command line first compile the standard library module
```
cl.exe /std:c++20 /MD /EHsc /nologo /W4 /c "%VCToolsInstallDir%\modules\std.ixx"
cl.exe /std:c++20 /MD /EHsc /nologo /W4 /c main.cpp
```
When you compile the `std.ixx` module you get a `std.ifc` in you local directory
Then when you compile `main.cpp` it find that `std.ifc` file and uses it

For the IDE see
https://developercommunity.visualstudio.com/t/using-standard-library-module-in--c20/10566630
This was closed as "Not a Bug"


## Clang

Clang does require variables to set simply setting the language version to 23 or greater does not work.

You do need to set `CMAKE_EXPERIMENTAL_CXX_IMPORT_STD` to get anything to work
```
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
```
You know if it's working because you will see a message like
```
 CMake's support for `import std;` in C++23 and newer is experimental.  It
  is meant only for experimentation and feedback to CMake developers.
```

### CMAKE_CXX_MODULE_STD
Setting `CMAKE_CXX_MODULE_STD` does seem to work and you do see changes in the output `build.ninja` file.
You do not need to add
```
target_compile_features(main PUBLIC cxx_std_23)
```
for this to work but it is probably a good idea to do that to guard against users setting a `CMAKE_CXX_STANDARD` lower than 23.

### CMAKE_CXX_SCAN_FOR_MODULES
Setting `CMAKE_CXX_SCAN_FOR_MODULES` does not seem to work.
you do see the
```
  CMake's support for `import std;` in C++23 and newer is experimental.  It
  is meant only for experimentation and feedback to CMake developers.
```
message but when you compile you get
```
 fatal error: module 'std' not found
```

### CMAKE_CXX_COMPILER_IMPORT_STD
This properties tells you if the compiler supports `import std`.
Its value is only set after the `project()` command. 
For clang 22 you get
```
CMAKE_CXX_COMPILER_IMPORT_STD="23;26"
```


### Clang standard library
This does assume you are using the clang standard library

### Ubuntu install

# Note only one libc++ version can be installed at a time if tou use the apt packages from https:/llvm.org
# https://github.com/llvm/llvm-project/issues/144501
# https://github.com/llvm/llvm-project/issues/148832
# See https://stackoverflow.com/questions/61165575/how-can-i-install-multiple-versions-of-llvm-libc-on-the-same-computer-at-the-s

## GCC



g++-15 -std=c++23 -fmodules -fsearch-include-path bits/std.cc  main.cpp


This results in a std.pcm file
clang++-22 -std=c++23 -stdlib=libc++ -Wno-reserved-identifier -Wno-reserved-module-identifier --precompile -o std.pcm /usr/lib/llvm-22/share/libc++/v1/std.cppm
clang++-22 -std=c++23 -stdlib=libc++ -fmodule-file=std=std.pcm -o foo std.pcm main.cpp



