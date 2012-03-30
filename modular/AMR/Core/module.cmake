vtk_module(vtkAMRCore
  DEPENDS 
    vtkCommonCore
    vtkCommonExecutionModel
    vtkParallelCore
    vtkFiltersGeneral
    vtkhdf5
    vtkIOXML
  TEST_DEPENDS
    vtkTestingCore
    vtkTestingRendering
  DEFAULT OFF)
