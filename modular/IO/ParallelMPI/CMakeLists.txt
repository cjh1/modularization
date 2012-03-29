include (FindMPI)
include_directories(${MPI_INCLUDE_PATH})

set(Kit_SRCS
  vtkMPIImageReader.cxx
  )

vtk_module_library(vtkIOParallelMPI ${Kit_SRCS})
