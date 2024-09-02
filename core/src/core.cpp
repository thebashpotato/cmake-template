#include <core/core.hpp>

using namespace example_core;

[[nodiscard]] auto factorial(int n) noexcept -> int
{
    int result = 1;

    while (n > 0)
    {
        result *= n;
        --n;
    }

    return result;
}
