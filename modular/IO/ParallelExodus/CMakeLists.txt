set(Module_SRCS
  vtkPExodusIIReader.cxx
  )

vtk_module_library(vtkIOParallelExodus ${Module_SRCS})
