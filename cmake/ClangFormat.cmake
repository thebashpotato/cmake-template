function(run_clang_format DIRECTORY)
  find_program(CLANG_FORMAT clang-format)

  if(CLANG_FORMAT)
    message(STATUS "Running clang-format on files in ${DIRECTORY}")

    # Glob all c++ files
    file(GLOB_RECURSE CPP_FILES ${DIRECTORY}/*.cpp)

    # Glob all header files
    file(GLOB_RECURSE HEADER_FILES ${DIRECTORY}/*.hpp)

    # Concat all files
    set(ALL_FILES ${CPP_FILES} ${HEADER_FILES})

    # Run clang-format on each file
    foreach(FILE ${ALL_FILES})
      execute_process(COMMAND clang-format -i ${FILE}
                      RESULT_VARIABLE RETURN_CODE)
      if(NOT RETURN_CODE EQUAL 0)
        message(FATAL_ERROR "Failed to run clang-format on file: ${FILE}")
      endif()
    endforeach()
  else()
    message(SEND_ERROR "clang-format requested but executable not found")
  endif()
endfunction()
