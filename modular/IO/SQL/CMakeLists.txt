
set(Kit_SRCS
  vtkDatabaseToTableReader.cxx
  vtkRowQuery.cxx
  vtkRowQueryToTable.cxx
  vtkSQLDatabase.cxx
  #  vtkSQLDatabaseGraphSource.cxx
  vtkSQLDatabaseSchema.cxx
  vtkSQLDatabaseTableSource.cxx
  #vtkSQLGraphReader.cxx
  vtkSQLQuery.cxx
  vtkTableToDatabaseWriter.cxx
  )

set(SQLite_SRCS
  vtkSQLiteDatabase.cxx
  vtkSQLiteQuery.cxx
  vtkSQLiteToTableReader.cxx
  vtkTableToSQLiteWriter.cxx
  )

include_directories(
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Utilities
  )

vtk_add_library(vtkIOSQL ${Kit_SRCS} ${SQLite_SRCS})
target_link_libraries(vtkIOSQL vtksys)
set_target_properties(vtkIOSQL PROPERTIES LINK_INTERFACE_LIBRARIES "")
