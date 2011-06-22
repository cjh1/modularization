
project(VTKStatExample)

if(NOT VTK_BINARY_DIR)
  find_package(VTK REQUIRED)
  include(${VTK_USE_FILE})
endif(NOT VTK_BINARY_DIR)

add_executable(ExampleKMeansStatistics ExampleKMeansStatistics.cxx)