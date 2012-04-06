find_package(MPI)
include_directories(${MPI_INCLUDE_PATH})

set(Kit_SRCS
  vtkPNetCDFPOPReader.cxx
  )

vtk_module_library(vtkIOParallelNetCDF ${Kit_SRCS})

target_link_libraries(vtkIOParallelNetCDF vtkNetCDF_cxx)
