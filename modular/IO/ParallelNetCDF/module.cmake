vtk_module(vtkIOParallelNetCDF
  GROUPS
    MPI
  DEPENDS
    vtkCommonCore
    vtkParallelMPI
  COMPILE_DEPENDS
    vtknetcdf
  )
