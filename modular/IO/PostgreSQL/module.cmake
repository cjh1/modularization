vtk_module(vtkIOPostgreSQL
  DEPENDS
    vtkCommonDataModel
  IMPLEMENTS
    vtkIOSQL
  TEST_DEPENDS
    vtkTestingIOSQL
  )
