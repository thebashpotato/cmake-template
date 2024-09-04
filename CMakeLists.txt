cmake_minimum_required(VERSION 3.21)

#
# Only set the cxx_standard if it is not set by someone else
#
if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 20)
endif()

# strongly encouraged to enable this globally to avoid conflicts between
# -Wpedantic being enabled and -std=c++20 and -std=gnu++20 for example when
# compiling with PCH enabled
set(CMAKE_CXX_EXTENSIONS OFF)

project(
  project_workspace
  VERSION 0.1.0
  DESCRIPTION "Templated cmake project for cross-platform C++ development"
  LANGUAGES CXX)

include(cmake/PreventInSourceBuilds.cmake)
include(cmake/ClangFormat.cmake)
include(ProjectOptions.cmake)

project_setup_options()
project_global_options()

include(Dependencies.cmake)
project_setup_dependencies()
project_local_options()

target_compile_features(project_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})
add_library(project_workspace::project_options ALIAS project_options)
add_library(project_workspace::project_warnings ALIAS project_warnings)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  enable_testing()
endif()

add_subdirectory(core)
add_subdirectory(app)
