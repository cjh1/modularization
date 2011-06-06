
SET(Kit_SRCS
  vtkClientSocket.cxx
  vtkDirectory.cxx
  vtkServerSocket.cxx
  vtkSocket.cxx
  vtkSocketCollection.cxx
  vtkThreadMessager.cxx
  vtkTimerLog.cxx
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${VTK_SOURCE_DIR}/Common/Core)

SET_SOURCE_FILES_PROPERTIES(
  vtkSocket
  ABSTRACT
)

if(NOT HAVE_SOCKETS)
  # Tell vtkSocket.cxx that there are no sockets on this platform.
  set_source_files_properties(vtkSocket.cxx PROPERTIES
    COMPILE_FLAGS -DVTK_SOCKET_FAKE_API)
endif()

if(WIN32 AND NOT BORLAND)
  set(KIT_LIBS ${KIT_LIBS} wsock32)
endif()

add_library(vtkCommonSystem ${Kit_SRCS})

target_link_libraries(vtkCommonSystem vtkCommonCore ${KIT_LIBS})
