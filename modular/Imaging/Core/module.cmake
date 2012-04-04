vtk_module(vtkImagingCore
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonTransforms
    vtkCommonMath
    vtkCommonComputationalGeometry
    vtkCommonExecutionModel
    vtkImagingMath
  TEST_DEPENDS
    vtkFiltersCore
    vtkFiltersModeling
    vtkFiltersGeneral
    vtkFiltersHybrid
    vtkRenderingCore
    vtkTestingRendering
    vtkInteractionStyle
    vtkImagingStencil # Move tests
    vtkImagingGeneral # Move tests
    vtkImagingStatistics # Move tests
    vtkRenderingImage # Move tests
  )
