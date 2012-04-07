set(Module_SRCS
  vtkPNetCDFPOPReader.cxx
  )

vtk_module_library(vtkIOParallelNetCDF ${Module_SRCS})

target_link_libraries(vtkIOParallelNetCDF vtkNetCDF_cxx)
