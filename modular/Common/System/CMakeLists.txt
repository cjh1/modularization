
SET(Kit_SRCS
vtkClientSocket.cxx
vtkClientSocket.h
vtkDirectory.cxx
vtkDirectory.h
vtkServerSocket.cxx
vtkServerSocket.h
vtkSocket.cxx
vtkSocket.h
vtkSocketCollection.cxx
vtkSocketCollection.h
vtkThreadMessager.cxx
vtkThreadMessager.h
vtkTimerLog.cxx
vtkTimerLog.h
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${VTK_SOURCE_DIR}/Common/Core)

SET_SOURCE_FILES_PROPERTIES(
  vtkSocket
  ABSTRACT
)

#SET_SOURCE_FILES_PROPERTIES(
#  WRAP_EXCLUDE
#)

#SET_SOURCE_FILES_PROPERTIES(
#  PROPERTIES WRAP_SPECIAL 1
#)

add_library(vtkCommonSystem ${Kit_SRCS})

target_link_libraries(vtkCommonSystem vtkCommonCore)
