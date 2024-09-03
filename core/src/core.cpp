#include <core/core.hpp>

namespace example_core
{

auto factorial(int n) noexcept -> int
{
    int result = 1;

    while (n > 0)
    {
        result *= n;
        --n;
    }

    return result;
}

} // namespace example_core
