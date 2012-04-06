vtk_module(vtkInfovisBoostGraphAlgorithms
  DEPENDS
    vtkInfovisCore
    vtkCommonExecutionModel
  TEST_DEPENDS
    # vtkViewsInfovis
    vtkRenderingOpenGL
    vtkTestingRendering
    vtkIOInfovis
  DEFAULT OFF)
