vtk_module(vtkIOSQL
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkIOCore
    vtksqlite
  COMPILE_DEPENDS
    kwsys
  DEFAULT ON)
