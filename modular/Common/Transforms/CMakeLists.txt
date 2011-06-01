
SET(Kit_SRCS
  vtkAbstractTransform.cxx
  vtkAbstractTransform.h
  vtkCylindricalTransform.cxx
  vtkCylindricalTransform.h
  vtkGeneralTransform.cxx
  vtkGeneralTransform.h
  vtkHomogeneousTransform.cxx
  vtkHomogeneousTransform.h
  vtkIdentityTransform.cxx
  vtkIdentityTransform.h
  vtkLinearTransform.cxx
  vtkLinearTransform.h
  vtkMatrixToHomogeneousTransform.cxx
  vtkMatrixToHomogeneousTransform.h
  vtkMatrixToLinearTransform.cxx
  vtkMatrixToLinearTransform.h
  vtkPerspectiveTransform.cxx
  vtkPerspectiveTransform.h
  vtkSphericalTransform.cxx
  vtkSphericalTransform.h
  vtkThinPlateSplineTransform.cxx
  vtkThinPlateSplineTransform.h
  vtkTransform2D.cxx
  vtkTransform2D.h
  vtkTransformCollection.cxx
  vtkTransformCollection.h
  vtkTransform.cxx
  vtkTransform.h
  vtkWarpTransform.cxx
  vtkWarpTransform.h
  vtkLandmarkTransform.cxx
  vtkLandmarkTransform.h
  vtkIterativeClosestPointTransform.cxx
  vtkIterativeClosestPointTransform.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
  ${VTK_SOURCE_DIR}/Common/DataModel
  )

#SET_SOURCE_FILES_PROPERTIES(
#ABSTRACT
#)

#SET_SOURCE_FILES_PROPERTIES(
#  WRAP_EXCLUDE
#)

#SET_SOURCE_FILES_PROPERTIES(
#  PROPERTIES WRAP_SPECIAL 1
#)

add_library(vtkCommonTransforms ${Kit_SRCS})

target_link_libraries(vtkCommonTransforms vtkCommonCore vtkCommonMath)
