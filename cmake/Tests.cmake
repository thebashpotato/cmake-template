function(myproject_enable_coverage myproject_name)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES
                                             ".*Clang")

    target_compile_options(${myproject_name} INTERFACE --coverage -O0 -g)
    target_link_libraries(${myproject_name} INTERFACE --coverage)
  endif()
endfunction()
