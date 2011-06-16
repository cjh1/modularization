
find_package(MySQL REQUIRED)

set(MySQL_SRCS
  vtkMySQLDatabase.cxx
  vtkMySQLQuery.cxx
  vtkMySQLToTableReader.cxx
  vtkTableToMySQLWriter.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/IO/SQL
  ${MYSQL_INCLUDE_DIRECTORIES}
  )

add_library(vtkIOMySQL ${MySQL_SRCS})

target_link_libraries(vtkIOMySQL vtkCommonDataModel vtkIOSQL
  ${MYSQL_LIBRARY} ${MYSQL_EXTRA_LIBRARIES})
