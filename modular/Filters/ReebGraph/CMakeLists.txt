find_package(Boost REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

set(Kit_SRCS
  vtkReebGraphSimplificationFilter.cxx
  vtkReebGraphSurfaceSkeletonFilter.cxx
  vtkReebGraphToJoinSplitTreeFilter.cxx
  vtkReebGraphVolumeSkeletonFilter.cxx
  vtkUnstructuredGridToReebGraphFilter.cxx
  )

# set_source_files_properties(
#   WRAP_EXCLUDE
#   )

# set_source_files_properties(
#   ABSTRACT
#   )

vtk_module_library(vtkFiltersReebGraph ${Kit_SRCS})
