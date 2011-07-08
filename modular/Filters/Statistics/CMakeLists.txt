
SET(Kit_SRCS
  vtkBivariateLinearTableThreshold.cxx
  vtkContingencyStatistics.cxx
  vtkCorrelativeStatistics.cxx
  vtkDescriptiveStatistics.cxx
  vtkKMeansDistanceFunctorCalculator.cxx
  vtkKMeansDistanceFunctor.cxx
  vtkKMeansStatistics.cxx
  vtkMultiCorrelativeStatistics.cxx
  vtkOrderStatistics.cxx
  vtkPCAStatistics.cxx
  vtkStatisticsAlgorithm.cxx
  vtkStrahlerMetric.cxx
  vtkStreamingStatistics.cxx
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
  )

add_library(vtkFiltersStatistics ${Kit_SRCS})

target_link_libraries(vtkFiltersStatistics vtkCommonCore vtkCommonMath
  vtkCommonDataModel
  vtkalglib)
