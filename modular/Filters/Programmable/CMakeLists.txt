set(Kit_SRCS
  vtkProgrammableAttributeDataFilter.cxx
  vtkProgrammableFilter.cxx
  vtkProgrammableGlyphFilter.cxx
  )

# set_source_files_properties(
#   WRAP_EXCLUDE
#   )

# set_source_files_properties(
#   ABSTRACT
#   )

vtk_module_library(vtkFiltersProgrammable ${Kit_SRCS})
