vtk_module(vtkIOSQL
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkIOCore
    vtksqlite
    vtksys
  TEST_DEPENDS
    vtkTestingIOSQL
    vtkTestingCore
  DEFAULT ON)
