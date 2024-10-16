#include <gtest/gtest.h>
#include <project_core/config.hpp>
#include <project_core/core.hpp>

using namespace project_core;

TEST(FactorialTestSuite, Test1)
{
    ASSERT_EQ(factorial(0), 1);
    ASSERT_EQ(factorial(1), 1);
    ASSERT_EQ(factorial(2), 2);
    ASSERT_EQ(factorial(3), 6);
    ASSERT_EQ(factorial(10), 3628800);
}

TEST(ConfigFileTestSuite, Test1)
{
    ASSERT_EQ(project_name, "project_core");
    ASSERT_EQ(project_version_major, 0);
    ASSERT_EQ(project_version_minor, 1);
    ASSERT_EQ(project_version_patch, 0);
}
