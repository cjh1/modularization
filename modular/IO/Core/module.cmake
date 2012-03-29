vtk_module(vtkIOCore
  DEPENDS
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkCommonMisc
    vtkzlib
    vtksys
  TEST_DEPENDS
   vtkTestingCore
  DEFAULT ON)
