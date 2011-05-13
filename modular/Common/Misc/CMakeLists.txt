
SET(Kit_SRCS
  #vtkAssemblyNode.cxx
  #vtkAssemblyNode.h
  #vtkAssemblyPath.cxx
  #vtkAssemblyPath.h
  #vtkAssemblyPaths.cxx
  #vtkAssemblyPaths.h
  vtkContourValues.cxx
  vtkContourValues.h
  vtkEdgeTable.cxx
  vtkEdgeTable.h
  vtkErrorCode.cxx
  vtkErrorCode.h
  vtkFunctionParser.cxx
  vtkFunctionParser.h
  vtkHeap.cxx
  vtkHeap.h
  vtkAbstractInterpolatedVelocityField.cxx
  vtkAbstractInterpolatedVelocityField.h
  vtkInterpolatedVelocityField.cxx
  vtkInterpolatedVelocityField.h
  vtkMarchingCubesCases.h
  vtkMarchingSquaresCases.h
  vtkScalarTree.cxx
  vtkScalarTree.h
  vtkSimpleScalarTree.cxx
  vtkSimpleScalarTree.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR} 
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
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

add_library(vtkCommonMisc ${Kit_SRCS})

target_link_libraries(vtkCommonMisc vtkCommonCore vtkCommonMath)
