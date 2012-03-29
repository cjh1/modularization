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
    vtkRenderingCore
    vtkIOXML
  DEFAULT ON)
