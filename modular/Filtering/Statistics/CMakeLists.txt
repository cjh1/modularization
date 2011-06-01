
SET(Kit_SRCS
vtkBivariateLinearTableThreshold.h
vtkBivariateLinearTableThreshold.cxx
vtkBivariateStatisticsAlgorithm.h
vtkBivariateStatisticsAlgorithm.cxx
vtkContingencyStatistics.h
vtkContingencyStatistics.cxx
vtkCorrelativeStatistics.h
vtkCorrelativeStatistics.cxx
vtkDescriptiveStatistics.h
vtkDescriptiveStatistics.cxx
vtkKMeansAssessFunctor.h
vtkKMeansDistanceFunctor.h
vtkKMeansDistanceFunctor.cxx
vtkKMeansDistanceFunctorCalculator.h
vtkKMeansDistanceFunctorCalculator.cxx
vtkKMeansStatistics.h
vtkKMeansStatistics.cxx
vtkMultiCorrelativeStatistics.h
vtkMultiCorrelativeStatistics.cxx
vtkMultiCorrelativeStatisticsAssessFunctor.h
vtkOrderStatistics.h
vtkOrderStatistics.cxx
vtkPCAStatistics.h
vtkPCAStatistics.cxx
vtkStatisticsAlgorithm.h
vtkStatisticsAlgorithm.cxx
vtkStatisticsAlgorithmPrivate.h
vtkStrahlerMetric.h
vtkStrahlerMetric.cxx
vtkStreamingStatistics.h
vtkStreamingStatistics.cxx
vtkUnivariateStatisticsAlgorithm.h
vtkUnivariateStatisticsAlgorithm.cxx
vtkRAdapter.cxx
vtkRAdapter.h
vtkRCalculatorFilter.cxx
vtkRCalculatorFilter.h
vtkRInterface.cxx
vtkRInterface.h
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

add_library(vtkFilteringStatistics ${Kit_SRCS})

target_link_libraries(vtkFilteringStatistics vtkCommonCore vtkCommonMath vtkCommonDataModel)
