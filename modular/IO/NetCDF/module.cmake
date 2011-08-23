vtk_module(vtkIONetCDF
  DEPENDS
    vtkCommonDataModel
    vtkCommonSystem
    vtkIOCore
  COMPILE_DEPENDS
    vtknetcdf
  DEFAULT ON)
