#include <core/core.hpp>
#include <cstdlib>
#include <spdlog/spdlog.h>

using namespace example_core;

auto main() -> int
{
    spdlog::info("Factorial 10 = {}", factorial(10));

    return EXIT_SUCCESS;
}
