
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

set(ODBC_SRCS
  vtkODBCDatabase.cxx
  vtkODBCQuery.cxx
  )

set(MySQL_SRCS
  vtkMySQLDatabase.cxx
  vtkMySQLQuery.cxx
  vtkMySQLToTableReader.cxx
  vtkTableToMySQLWriter.cxx
  )

set(PGSQL_SRCS
  vtkPostgreSQLDatabase.cxx
  vtkPostgreSQLQuery.cxx
  vtkPostgreSQLToTableReader.cxx
  vtkTableToPostgreSQLWriter.cxx
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/Utilities
  )

add_library(vtkIOSQL ${Kit_SRCS} ${SQLite_SRCS})

target_link_libraries(vtkIOSQL vtkCommonDataModel vtkIOCore vtksqlite)
