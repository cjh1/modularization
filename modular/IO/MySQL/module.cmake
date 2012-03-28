vtk_module(vtkIOMySQL
  DEPENDS
    vtkCommonDataModel
  IMPLEMENTS
    vtkIOSQL
  TEST_DEPENDS
    vtkTestingIOSQL
    vtkIOMySQL
  DEFAULT OFF)
