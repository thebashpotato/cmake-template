#include <spdlog/spdlog.h>

#include <cstdlib>
#include <myproject_core/config.hpp>
#include <myproject_core/core.hpp>

using namespace myproject_core;

auto main() -> int {
  spdlog::info("{} {}", myproject_name, myproject_version);
  spdlog::info("Factorial 10 = {}", factorial(10));

  return EXIT_SUCCESS;
}
