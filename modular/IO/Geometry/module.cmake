vtk_module(vtkIOGeometry
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonMisc
    vtkIOCore
    vtkzlib
    vtksys
  COMPILE_DEPENDS
    MaterialLibrary
  DEFAULT ON)
