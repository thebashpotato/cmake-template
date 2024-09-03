# Cmake Template

Templated cmake project for cross-platform C++ development

> A simplified and customized version of Jason Turners [C++ best practices template](https://github.com/cpp-best-practices/cmake_template)

## About

- Supports Clang, GNU, and MSVC toolchains (Compiles on Linux, MacOS and Windows out of the box).
- Uses clang-format with Microsoft style.
- Setup in a workspace style, where the top level CMakeLists.txt delegates lower level cmake files to clearly seperate shared/static libraries and exectubles. Great for mono repos.
- All static analyzers/tooling is setup (clang-tidy, cpp-check, include what you use) as well as santizers.
- Uses [CPM](https://github.com/cpm-cmake/CPM.cmake) for package management.
- Uses the googletest unit-testing/mocking library.
- Utilizes a `.vscode/tasks.json` for compiling and running tests, and a `.vscode/launch.json` for debugging. VScode, Neovim, and Emacs can all use these files. (The two latter have plugins).

## Usage

### Use the Github template

First, click the `Use this template` button at the top of this page.

### Additional Details

1. Read [this](./docs/make_it_your_own.md) for CMake variables you will need to change to conform the template to your project.
2. Read [this](./docs/dependencies.md) for host platform dependencies
3. Read [this](./docs/building.md) for building instructions

## License

MIT © Matt Williams
