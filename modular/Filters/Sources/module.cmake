vtk_module(vtkFiltersSources
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkCommonTransforms
    vtkCommonMath
    vtkCommonComputationalGeometry
    vtkFiltersCore
    vtkFiltersGeneral
  TEST_DEPENDS
    vtkTestingCore
    vtkTestingRendering
    vtkRenderingCore
    vtkRenderingFreeType
    vtkFiltersModeling
    vtkIOXML
  DEFAULT ON)
