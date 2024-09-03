#include <cstdlib>
#include <example_core/core.hpp>
#include <example_core/config.hpp>
#include <spdlog/spdlog.h>

using namespace example_core;

auto main() -> int
{
    spdlog::info("{} {}", project_name, project_version);
    spdlog::info("Factorial 10 = {}", factorial(10));

    return EXIT_SUCCESS;
}
