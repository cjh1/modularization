include (FindMPI)
include_directories(${MPI_INCLUDE_PATH})

set(Kit_SRCS
  vtkEnSightWriter.cxx
  # vtkExodusIIWriter.cxx needs vtkMultiProcessController
  vtkPChacoReader.cxx
  vtkPCosmoReader.cxx
  vtkPDataSetReader.cxx
  vtkPDataSetWriter.cxx
  vtkPImageWriter.cxx
  vtkPNrrdReader.cxx
  vtkPOpenFOAMReader.cxx
  vtkPSLACReader.cxx
  vtkVPICReader.cxx
  vtkWindBladeReader.cxx
  vtkXMLPHierarchicalBoxDataWriter.cxx
  vtkXMLPMultiBlockDataWriter.cxx
  )

vtk_module_library(vtkIOParallel ${Kit_SRCS})
