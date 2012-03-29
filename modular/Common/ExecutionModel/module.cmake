vtk_module(vtkCommonExecutionModel
  DEPENDS
    vtkCommonCore
    vtkCommonMath
    vtkCommonDataModel
    vtkCommonSystem
  COMPILE_DEPENDS
    vtkCommonMisc
  TEST_DEPENDS
    vtkTestingCore
    vtkIOCore
    vtkIOGeometry
    vtkFiltersExtraction
  DEFAULT ON)
