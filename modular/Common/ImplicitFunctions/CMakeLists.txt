
SET(Kit_SRCS
vtkCone.cxx
vtkCone.h
vtkCylinder.cxx
vtkCylinder.h
vtkImplicitBoolean.cxx
vtkImplicitBoolean.h
vtkImplicitDataSet.cxx
vtkImplicitDataSet.h
vtkImplicitFunction.cxx
vtkImplicitFunction.h
vtkImplicitFunctionCollection.cxx
vtkImplicitFunctionCollection.h
vtkImplicitHalo.cxx
vtkImplicitHalo.h
vtkImplicitSelectionLoop.cxx
vtkImplicitSelectionLoop.h
vtkImplicitSum.cxx
vtkImplicitSum.h
vtkImplicitVolume.cxx
vtkImplicitVolume.h
vtkImplicitWindowFunction.cxx
vtkImplicitWindowFunction.h
vtkPerlinNoise.cxx
vtkPerlinNoise.h
vtkPlane.cxx
vtkPlane.h
vtkPlaneCollection.cxx
vtkPlaneCollection.h
vtkPlanes.cxx
vtkPlanes.h
vtkPlanesIntersection.cxx
vtkPlanesIntersection.h
vtkPolyPlane.h
vtkQuadric.cxx
vtkQuadric.h
vtkSphere.cxx
vtkSphere.h
vtkSuperquadric.cxx
vtkSuperquadric.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR} 
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
  ${VTK_SOURCE_DIR}/Common/Misc
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

add_library(vtkImplicitFunctions ${Kit_SRCS})

target_link_libraries(vtkImplicitFunctions vtkCommonCore vtkCommonMath vtkCommonMisc)
