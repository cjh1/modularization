vtk_module(vtkIONetCDF
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkIOCore
  COMPILE_DEPENDS
    vtknetcdf
    kwsys
  DEFAULT ON)
