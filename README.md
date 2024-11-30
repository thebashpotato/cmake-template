# Cross Platform CMake Template

Templated cmake project for cross-platform C++ development

> A simplified and customized version of Jason Turners [C++ best practices template](https://github.com/cpp-best-practices/cmake_template)

## About

- Supports Clang, GNU, and MSVC toolchains (Compiles on Linux, MacOS and Windows out of the box).
- Uses clang-format with Microsoft style.
- Setup in a workspace style, where the top level CMakeLists.txt delegates lower level cmake files to clearly seperate shared/static libraries and exectubles. Great for mono repos.
- All static analyzers/tooling is setup (clang-tidy, cpp-check, include what you use) as well as santizers.
- Uses [CPM](https://github.com/cpm-cmake/CPM.cmake) for package management.
- Uses the googletest unit-testing/mocking library.
- Utilizes a `.vscode/tasks.json` for compiling and running tests, and a `.vscode/launch.json` for debugging. VScode, Neovim, and Emacs can all use these files. (The two latter have plugins). You can also use the commands as examples to use in a Makefile.
- Also provides a `CMakePresets.json` for IDE integration.
- The [core](./core/CMakeLists.txt) project is an example library
- The [app](./app/CMakeLists.txt) project is an example binary application (links against the `core` lib)

## Usage

1. The [ProjectOptions.cmake](./ProjectOptions.cmake) file contains the CMake `option()` calls for the project.
    - option(myproject_ENABLE_IPO)
    - option(myproject_WARNINGS_AS_ERRORS)
    - option(myproject_ENABLE_USER_LINKER)
    - option(myproject_ENABLE_SANITIZER_ADDRESS)
    - option(myproject_ENABLE_SANITIZER_LEAK)
    - option(myproject_ENABLE_SANITIZER_UNDEFINED)
    - option(myproject_ENABLE_SANITIZER_THREAD)
    - option(myproject_ENABLE_SANITIZER_MEMORY)
    - option(myproject_ENABLE_UNITY_BUILD)
    - option(myproject_ENABLE_CLANG_TIDY)
    - option(myproject_ENABLE_CPPCHECK)
    - option(myproject_ENABLE_PCH)
    - option(myproject_ENABLE_CACHE)

2. The [Dependencies.cmake](./Dependencies.cmake) file provides CPM for package management.


### Use the Github template

First, click the `Use this template` button at the top of this page.

### Additional Details

1. Read [this](./docs/make_it_your_own.md) for variables/folder names you will need to change to conform the template to your project.
2. Read [this](./docs/dependencies.md) for host platform dependencies
3. Read [this](./docs/building.md) for building instructions

## License

MIT © Matt Williams
