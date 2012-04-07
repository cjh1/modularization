vtk_module(vtkIOSQL
  DEPENDS
    vtkCommonDataModel
    vtkIOCore
    vtksqlite # We should consider splitting this into a module.
  TEST_DEPENDS
    vtkTestingIOSQL
    vtkTestingCore
  DEFAULT ON)
