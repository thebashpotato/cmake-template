include(GoogleTest)

#
# Add all test source files
#
set(TEST_SOURCE_FILES tests.cpp)

#
# Declare a custom name for the text executable
#
set(PROJECT_UNIT_TEST "${PROJECT_NAME}_tests")

#
# Add all test sources to the executable, and any other sources
#
add_executable(${PROJECT_UNIT_TEST} ${TEST_SOURCE_FILES})

#
# Link all libs to test executable
#
target_include_directories(${PROJECT_UNIT_TEST} PUBLIC ${PACKAGE_INCLUDE_DIR})
target_link_libraries(${PROJECT_UNIT_TEST}
                      PRIVATE myproject_options myproject_warnings gtest gtest_main)

#
# Instruct gtest to discover all tests
#
gtest_discover_tests(${PROJECT_UNIT_TEST})
