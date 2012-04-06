vtk_module(vtkIOPLY
  DEPENDS
    vtkCommonCore
    vtkCommonMisc
    vtkCommonExecutionModel
    vtkIOGeometry
  TEST_DEPENDS
    vtkRenderingOpenGL
    vtkIOImage
    vtkTestingRendering
  DEFAULT ON)
