vtk_module(vtkIOMySQL
  DEPENDS
    vtkCommonDataModel
  IMPLEMENTS
    vtkIOSQL
  TEST_DEPENDS
    vtkTestingCore
    vtkTestingIOSQL
  DEFAULT OFF)
