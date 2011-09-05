SET(Kit_SRCS
  vtkChacoGraphReader.cxx
  vtkChacoGraphReader.h
  vtkDelimitedTextReader.cxx
  vtkDelimitedTextReader.h
  vtkDIMACSGraphReader.cxx
  vtkDIMACSGraphReader.h
  vtkDIMACSGraphWriter.cxx
  vtkDIMACSGraphWriter.h
  vtkFixedWidthTextReader.cxx
  vtkFixedWidthTextReader.h
  vtkISIReader.cxx
  vtkISIReader.h
  vtkRISReader.cxx
  vtkRISReader.h
  vtkTulipReader.cxx
  vtkTulipReader.h
  vtkXGMLReader.cxx
  vtkXGMLReader.h
  vtkXMLTreeReader.cxx
  vtkXMLTreeReader.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Utilities
  )

vtk_add_library(vtkIOInfovis ${Kit_SRCS})
target_link_libraries(vtkIOInfovis vtksys)
set_target_properties(vtkIOInfovis PROPERTIES LINK_INTERFACE_LIBRARIES "")
