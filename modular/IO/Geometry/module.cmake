vtk_module(vtkIOGeometry
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonMisc
    vtkIOCore
    vtkzlib
  COMPILE_DEPENDS
    MaterialLibrary
    kwsys
  DEFAULT ON)
