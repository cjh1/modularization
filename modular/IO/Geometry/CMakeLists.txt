
SET(Kit_SRCS
  vtkAVSucdReader.cxx
  vtkBYUReader.cxx
  vtkBYUWriter.cxx
  #vtkCGMWriter.cxx # Needs vtkViewport.
  vtkChacoReader.cxx
  vtkCompositeDataReader.cxx
  vtkCompositeDataWriter.cxx
  vtkDataSetReader.cxx
  vtkDataSetWriter.cxx
  vtkFacetWriter.cxx
  vtkFLUENTReader.cxx
  vtkGAMBITReader.cxx
  vtkGenericDataObjectReader.cxx
  vtkGenericDataObjectWriter.cxx
  vtkGenericMovieWriter.cxx
  #vtkIVWriter.cxx # Needs vtkAbstractMapper
  vtkMaterialLibrary.cxx
  vtkMCubesReader.cxx
  vtkMCubesWriter.cxx
  vtkMFIXReader.cxx
  vtkMoleculeReaderBase.cxx
  vtkMultiBlockPLOT3DReader.cxx
  vtkOBJReader.cxx
  vtkOpenFOAMReader.cxx
  vtkParticleReader.cxx
  vtkPDBReader.cxx
  vtkPLOT3DReader.cxx
  vtkPolyDataReader.cxx
  vtkPolyDataWriter.cxx
  vtkProStarReader.cxx
  vtkRectilinearGridReader.cxx
  vtkRectilinearGridWriter.cxx
  vtkSESAMEReader.cxx
  vtkSimplePointsReader.cxx
  vtkSimplePointsWriter.cxx
  vtkSTLReader.cxx
  vtkSTLWriter.cxx
  vtkStructuredGridReader.cxx
  vtkStructuredGridWriter.cxx
  vtkTecplotReader.cxx
  vtkTreeReader.cxx
  vtkTreeWriter.cxx
  vtkUGFacetReader.cxx
  vtkUnstructuredGridReader.cxx
  vtkUnstructuredGridWriter.cxx

  vtkStructuredPointsReader.cxx
  vtkStructuredPointsWriter.cxx

  vtkShaderCodeLibrary.cxx

  vtkXYZMolReader.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Utilities/utf8/source
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/System
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/IO/SQL
  ${VTK_SOURCE_DIR}/Utilities
  ${VTK_BINARY_DIR}/Utilities/MaterialLibrary
  )

add_library(vtkIOGeometry ${Kit_SRCS})

target_link_libraries(vtkIOGeometry vtkCommonDataModel vtkCommonSystem
  vtkIOCore)
