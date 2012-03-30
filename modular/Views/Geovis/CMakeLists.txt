set(Kit_SRCS
  vtkGeoView.cxx
  vtkGeoView2D.cxx
  )

# set_source_files_properties(
#   WRAP_EXCLUDE
#   )

# set_source_files_properties(
#   ABSTRACT
#   )

vtk_module_library(vtkViewsGeovis ${Kit_SRCS})
