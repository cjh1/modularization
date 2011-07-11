
SET(Kit_SRCS
vtkXMLCompositeDataReader.cxx
  vtkXMLCompositeDataWriter.cxx
  vtkXMLDataParser.cxx
  vtkXMLDataReader.cxx
  vtkXMLDataSetWriter.cxx
  vtkXMLFileReadTester.cxx
  vtkXMLGenericDataObjectReader.cxx
  vtkXMLHierarchicalBoxDataReader.cxx
  vtkXMLHierarchicalBoxDataWriter.cxx
  vtkXMLHierarchicalDataReader.cxx
  vtkXMLHyperOctreeReader.cxx
  vtkXMLHyperOctreeWriter.cxx
  vtkXMLImageDataReader.cxx
  vtkXMLImageDataWriter.cxx
  vtkXMLMaterial.cxx
  vtkXMLMaterialParser.cxx
  vtkXMLMaterialReader.cxx
  vtkXMLMultiBlockDataReader.cxx
  vtkXMLMultiBlockDataWriter.cxx
  vtkXMLMultiGroupDataReader.cxx
  vtkXMLParser.cxx
  vtkXMLPDataReader.cxx
  vtkXMLPDataSetWriter.cxx
  vtkXMLPDataWriter.cxx
  vtkXMLPImageDataReader.cxx
  vtkXMLPImageDataWriter.cxx
  vtkXMLPolyDataReader.cxx
  vtkXMLPolyDataWriter.cxx
  vtkXMLPPolyDataReader.cxx
  vtkXMLPPolyDataWriter.cxx
  vtkXMLPRectilinearGridReader.cxx
  vtkXMLPRectilinearGridWriter.cxx
  vtkXMLPStructuredDataReader.cxx
  vtkXMLPStructuredDataWriter.cxx
  vtkXMLPStructuredGridReader.cxx
  vtkXMLPStructuredGridWriter.cxx
  vtkXMLPUnstructuredDataReader.cxx
  vtkXMLPUnstructuredDataWriter.cxx
  vtkXMLPUnstructuredGridReader.cxx
  vtkXMLPUnstructuredGridWriter.cxx
  vtkXMLReader.cxx
  vtkXMLRectilinearGridReader.cxx
  vtkXMLRectilinearGridWriter.cxx
  vtkXMLShader.cxx
  vtkXMLStructuredDataReader.cxx
  vtkXMLStructuredDataWriter.cxx
  vtkXMLStructuredGridReader.cxx
  vtkXMLStructuredGridWriter.cxx
  vtkXMLUnstructuredDataReader.cxx
  vtkXMLUnstructuredDataWriter.cxx
  vtkXMLUnstructuredGridReader.cxx
  vtkXMLUnstructuredGridWriter.cxx
  vtkXMLUtilities.cxx
  vtkXMLWriterC.cxx
  vtkXMLWriter.cxx
#  vtkXYZMolReader.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/IO/Geometry
  ${VTK_SOURCE_DIR}/Utilities
  )

add_library(vtkIOXML ${Kit_SRCS})

target_link_libraries(vtkIOXML vtkCommonDataModel vtkIOGeometry vtkexpat)
