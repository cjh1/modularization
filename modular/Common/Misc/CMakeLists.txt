
SET(Kit_SRCS
  vtkContourValues.cxx
  vtkErrorCode.cxx
  vtkFunctionParser.cxx
  vtkHeap.cxx
  vtkMarchingCubesCases.h
  vtkMarchingSquaresCases.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
  )

add_library(vtkCommonMisc ${Kit_SRCS})

target_link_libraries(vtkCommonMisc vtkCommonCore vtkCommonMath)
