find_package(MPI)
include_directories(${MPI_INCLUDE_PATH})

set(Kit_SRCS
  vtkPExodusIIReader.cxx
  )

vtk_module_library(vtkIOParallelExodus ${Kit_SRCS})
