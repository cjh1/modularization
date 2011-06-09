
SET(Kit_SRCS
  vtkPContingencyStatistics.h
  vtkPContingencyStatistics.cxx
  vtkPCorrelativeStatistics.h
  vtkPCorrelativeStatistics.cxx
  vtkPDescriptiveStatistics.h
  vtkPDescriptiveStatistics.cxx
  vtkPKMeansStatistics.h
  vtkPKMeansStatistics.cxx
  vtkPMultiCorrelativeStatistics.h
  vtkPMultiCorrelativeStatistics.cxx
  vtkPOrderStatistics.h
  vtkPOrderStatistics.cxx
  vtkPPCAStatistics.h
  vtkPPCAStatistics.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Utilities/vtkalglib
  ${VTK_BINARY_DIR}/Utilities/vtkalglib
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Math
  ${VTK_SOURCE_DIR}/Common/System
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/Filters/Statistics
  ${VTK_SOURCE_DIR}/Parallel/Core
  )

add_library(vtkFiltersParallelStatistics ${Kit_SRCS})

target_link_libraries(vtkFiltersParallelStatistics
  vtkCommonCore
  vtkCommonMath
  vtkCommonDataModel
  vtkalglib
  vtkFiltersStatistics
  vtkParallelCore
  )
