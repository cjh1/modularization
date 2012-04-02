
SET(Kit_SRCS
  vtkPContingencyStatistics.cxx
  vtkPCorrelativeStatistics.cxx
  vtkPDescriptiveStatistics.cxx
  vtkPKMeansStatistics.cxx
  vtkPMultiCorrelativeStatistics.cxx
  vtkPOrderStatistics.cxx
  vtkPPCAStatistics.cxx
  vtkPBivariateLinearTableThreshold.cxx
  )

vtk_module_library(vtkFiltersParallelStatistics ${Kit_SRCS})
