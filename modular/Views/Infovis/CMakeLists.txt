find_package(Boost REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

SET(Module_SRCS
  vtkApplyColors.cxx
  vtkApplyIcons.cxx
  vtkGraphLayoutView.cxx
  vtkHierarchicalGraphPipeline.cxx
  vtkHierarchicalGraphView.cxx
  vtkIcicleView.cxx
  vtkInteractorStyleAreaSelectHover.cxx
  vtkInteractorStyleTreeMapHover.cxx
  vtkParallelCoordinatesHistogramRepresentation.cxx
  vtkParallelCoordinatesRepresentation.cxx
  vtkParallelCoordinatesView.cxx
  vtkPipelineGraphSource.cxx
  vtkRenderedGraphRepresentation.cxx
  vtkRenderedHierarchyRepresentation.cxx
  vtkRenderedRepresentation.cxx
  vtkRenderedSurfaceRepresentation.cxx
  vtkRenderedTreeAreaRepresentation.cxx
  vtkRenderView.cxx
  vtkTreeAreaView.cxx
  vtkTreeMapView.cxx
  vtkTreeRingView.cxx
  vtkViewUpdater.cxx
  )

vtk_module_library(vtkViewsInfovis ${Module_SRCS})
