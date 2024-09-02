include(cmake/SystemLink.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)

macro(project_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                   ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                   ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(project_setup_options)
  option(project_ENABLE_HARDENING "Enable hardening" ON)
  option(project_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    project_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies" ON
    project_ENABLE_HARDENING OFF)

  project_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR project_PACKAGING_MAINTAINER_MODE)
    option(project_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(project_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(project_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(project_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(project_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(project_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(project_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(project_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(project_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(project_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(project_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(project_ENABLE_PCH "Enable precompiled headers" OFF)
    option(project_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(project_ENABLE_IPO "Enable IPO/LTO" ON)
    option(project_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(project_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(project_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer"
           ${SUPPORTS_ASAN})
    option(project_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(project_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer"
           ${SUPPORTS_UBSAN})
    option(project_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(project_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(project_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(project_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(project_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(project_ENABLE_PCH "Enable precompiled headers" OFF)
    option(project_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      project_ENABLE_IPO
      project_WARNINGS_AS_ERRORS
      project_ENABLE_USER_LINKER
      project_ENABLE_SANITIZER_ADDRESS
      project_ENABLE_SANITIZER_LEAK
      project_ENABLE_SANITIZER_UNDEFINED
      project_ENABLE_SANITIZER_THREAD
      project_ENABLE_SANITIZER_MEMORY
      project_ENABLE_UNITY_BUILD
      project_ENABLE_CLANG_TIDY
      project_ENABLE_CPPCHECK
      project_ENABLE_COVERAGE
      project_ENABLE_PCH
      project_ENABLE_CACHE)
  endif()
endmacro()

macro(project_global_options)
  if(project_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    project_enable_ipo()
  endif()

  project_supports_sanitizers()

  if(project_ENABLE_HARDENING AND project_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN
       OR project_ENABLE_SANITIZER_UNDEFINED
       OR project_ENABLE_SANITIZER_ADDRESS
       OR project_ENABLE_SANITIZER_THREAD
       OR project_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message(
      "${project_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${project_ENABLE_SANITIZER_UNDEFINED}"
    )
    project_enable_hardening(project_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(project_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(project_warnings INTERFACE)
  add_library(project_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  set_project_warnings(project_warnings ${project_WARNINGS_AS_ERRORS} "" "" ""
                       "")

  if(project_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    project_configure_linker(project_options)
  endif()

  include(cmake/Sanitizers.cmake)
  project_enable_sanitizers(
    project_options ${project_ENABLE_SANITIZER_ADDRESS}
    ${project_ENABLE_SANITIZER_LEAK} ${project_ENABLE_SANITIZER_UNDEFINED}
    ${project_ENABLE_SANITIZER_THREAD} ${project_ENABLE_SANITIZER_MEMORY})

  set_target_properties(project_options
                        PROPERTIES UNITY_BUILD ${project_ENABLE_UNITY_BUILD})

  if(project_ENABLE_PCH)
    target_precompile_headers(project_options INTERFACE <vector> <string>
                              <utility>)
  endif()

  if(project_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    project_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(project_ENABLE_CLANG_TIDY)
    project_enable_clang_tidy(project_options ${project_WARNINGS_AS_ERRORS})
  endif()

  if(project_ENABLE_CPPCHECK)
    project_enable_cppcheck(
      ${project_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(project_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    project_enable_coverage(project_options)
  endif()

  if(project_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(project_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(project_ENABLE_HARDENING AND NOT project_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN
       OR project_ENABLE_SANITIZER_UNDEFINED
       OR project_ENABLE_SANITIZER_ADDRESS
       OR project_ENABLE_SANITIZER_THREAD
       OR project_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    project_enable_hardening(project_options OFF
                             ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()
