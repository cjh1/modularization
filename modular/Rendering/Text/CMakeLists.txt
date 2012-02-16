set(Kit_SRCS
  vtkScaledTextActor.cxx
  vtkTextActor3D.cxx
  vtkTextActor.cxx
  vtkTextMapper.cxx
  vtkTextProperty.cxx
  vtkVectorText.cxx
  vtkFreeTypeStringToImage.cxx
  vtkFreeTypeUtilities.cxx
  vtkFreeTypeTools.cxx
  )
include_directories(
  ${VTK_SOURCE_DIR}/Rendering/FreeType
  )
vtk_module_library(vtkRenderingText ${Kit_SRCS})
