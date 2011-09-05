vtk_module(vtkIOXML
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonMisc
    vtkIOCore
    vtkIOGeometry
    vtkexpat
  COMPILE_DEPENDS
    kwsys
  DEFAULT ON)
