
SET(Kit_SRCS
  vtkAbstractTransform.cxx
  vtkCylindricalTransform.cxx
  vtkGeneralTransform.cxx
  vtkHomogeneousTransform.cxx
  vtkIdentityTransform.cxx
  vtkLinearTransform.cxx
  vtkMatrixToHomogeneousTransform.cxx
  vtkMatrixToLinearTransform.cxx
  vtkPerspectiveTransform.cxx
  vtkSphericalTransform.cxx
  vtkThinPlateSplineTransform.cxx
  vtkTransform2D.cxx
  vtkTransformCollection.cxx
  vtkTransform.cxx
  vtkWarpTransform.cxx
  vtkLandmarkTransform.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
  )

add_library(vtkCommonTransforms ${Kit_SRCS})

target_link_libraries(vtkCommonTransforms vtkCommonCore vtkCommonMath)
