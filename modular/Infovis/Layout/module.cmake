vtk_module(vtkInfovisLayout
  DEPENDS
    vtkCommonCore
    vtkCommonExecutionModel
    vtkImagingHybrid
    vtkFiltersModeling
    vtkInfovisCore
  TEST_DEPENDS
    vtkRenderingLabel
    vtkRenderingCore
    vtkTestingRendering
    vtkIOInfovis
  DEFAULT ON)
