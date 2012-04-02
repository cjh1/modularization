set(Kit_SRCS
  vtkPComputeHistogram2DOutliers.cxx
  vtkPExtractHistogram2D.cxx
  vtkPPairwiseExtractHistogram2D.cxx
  )

vtk_module_library(vtkFiltersParallelImaging ${Kit_SRCS})
