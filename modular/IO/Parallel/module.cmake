vtk_module(vtkIOParallel
  DEPENDS
  vtkParallelCore
  vtkFiltersParallel
  vtkIOParallelMPI
  vtkIONetCDF
  vtkexodusII
  vtkVPIC
  TEST_DEPENDS
  vtkTestingCore
  DEFAULT ON)
