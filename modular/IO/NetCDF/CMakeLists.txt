
SET(Kit_SRCS
  vtkMPASReader.cxx
  vtkNetCDFCAMReader.cxx
  vtkNetCDFCFReader.cxx
  vtkNetCDFPOPReader.cxx
  vtkNetCDFReader.cxx
  vtkSLACParticleReader.cxx
  vtkSLACReader.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/Utilities
  )

add_library(vtkIONetCDF ${Kit_SRCS})

target_link_libraries(vtkIONetCDF vtkCommonDataModel vtkCommonSystem
  vtkIOCore vtkNetCDF_cxx)
