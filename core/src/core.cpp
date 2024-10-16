#include <project_core/core.hpp>

namespace project_core
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

} // namespace project_core
