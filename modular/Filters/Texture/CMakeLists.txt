set(Kit_SRCS
  vtkTextureMapToCylinder.cxx
  vtkTextureMapToPlane.cxx
  vtkTextureMapToSphere.cxx
  vtkImplicitTextureCoords.cxx
  vtkThresholdTextureCoords.cxx
  vtkTransformTextureCoords.cxx
  vtkTriangularTCoords.cxx
  )

# set_source_files_properties(
#   WRAP_EXCLUDE
#   )

# set_source_files_properties(
#   ABSTRACT
#   )

vtk_module_library(vtkFiltersTexture ${Kit_SRCS})
