#include <core/core.hpp>
#include <gtest/gtest.h>

using namespace example_core;

TEST(FactorialTestSuite, Test1)
{
    ASSERT_EQ(factorial(0), 1);
    ASSERT_EQ(factorial(1), 1);
    ASSERT_EQ(factorial(2), 2);
    ASSERT_EQ(factorial(3), 6);
    ASSERT_EQ(factorial(10), 3628800);
}
