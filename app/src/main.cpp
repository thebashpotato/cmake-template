#include <cstdlib>
#include <project_core/config.hpp>
#include <project_core/core.hpp>
#include <spdlog/spdlog.h>

using namespace project_core;

auto main() -> int
{
    spdlog::info("{} {}", project_name, project_version);
    spdlog::info("Factorial 10 = {}", factorial(10));

    return EXIT_SUCCESS;
}
