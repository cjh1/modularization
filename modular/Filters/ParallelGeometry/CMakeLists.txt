set(Kit_SRCS
  vtkPDataSetGhostGenerator.cxx
  vtkPStructuredGridConnectivity.cxx
  vtkPStructuredGridGhostDataGenerator.cxx
  vtkPUniformGridGhostDataGenerator.cxx
  )

# set_source_files_properties(
#   WRAP_EXCLUDE
#   )

set_source_files_properties(
  vtkPDataSetGhostGenerator
  ABSTRACT
  )

vtk_module_library(vtkFiltersParallelGeometry ${Kit_SRCS})
