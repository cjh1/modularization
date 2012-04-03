vtk_module(vtkFiltersGeometry
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkFiltersCore
  TEST_DEPENDS
    vtkIOXML
    vtkRenderingOpenGL
    vtkTestingRendering
  DEFAULT ON)
