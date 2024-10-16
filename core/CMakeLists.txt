project(
  project_core
  VERSION 0.1.0
  DESCRIPTION "Example library"
  LANGUAGES CXX)

#
# Set our source and include directory variables for use through the build
#
set(PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(PACKAGE_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(PACKAGE_TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tests")

#
# Add all source files
#
set(SOURCE_FILES "${PACKAGE_SOURCE_DIR}/core.cpp")

#
# Output build information
#
message(STATUS "Building ${PROJECT_NAME} in [${CMAKE_BUILD_TYPE}] mode")

#
# Add tests if in Debug mode
#
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "Tests active for ${PROJECT_NAME}")
  add_subdirectory(tests)
endif()

#
# Generate configuration file
#
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configure_files/config.hpp.in
               ${PACKAGE_INCLUDE_DIR}/${PROJECT_NAME}/config.hpp)

#
# Create the library
#
add_library(${PROJECT_NAME} STATIC ${SOURCE_FILES})

# Link required dependencies
target_link_libraries(${PROJECT_NAME} PRIVATE project_options project_warnings
                                              fmt::fmt spdlog::spdlog)

target_include_directories(
  ${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${PACKAGE_INCLUDE_DIR}>
                         $<INSTALL_INTERFACE:include>)

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_${CMAKE_CXX_STANDARD})

set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES VERSION ${PROJECT_VERSION}
             CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  run_clang_format(${PACKAGE_INCLUDE_DIR})
  run_clang_format(${PACKAGE_SOURCE_DIR})
  run_clang_format(${PACKAGE_TEST_DIR})
endif()
