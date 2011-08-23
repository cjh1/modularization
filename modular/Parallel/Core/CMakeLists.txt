
SET(Kit_SRCS
  vtkCommunicator.cxx
  vtkDummyCommunicator.cxx
  vtkDummyController.cxx
  vtkMultiProcessController.cxx
  vtkMultiProcessStream.cxx
#  vtkParallelFactory.cxx
#  vtkParallelFactory.h
  vtkProcess.cxx
  vtkProcessGroup.cxx
  vtkSocketCommunicator.cxx
  vtkSocketController.cxx
  vtkSubCommunicator.cxx
  vtkSubGroup.cxx
  )

# Generate "vtkSocketCommunicatorHash.h".
add_custom_command(
  OUTPUT ${VTK_BINARY_DIR}/Parallel/Core/vtkSocketCommunicatorHash.h
  DEPENDS ${VTK_SOURCE_DIR}/Parallel/Core/vtkSocketCommunicator.cxx
          vtkHashSource
  COMMAND vtkHashSource
    ${VTK_SOURCE_DIR}/Parallel/Core/vtkSocketCommunicator.cxx
    vtkSocketCommunicatorHash vtkSocketCommunicatorHash.h
  )

set(Kit_SRCS
  ${Kit_SRCS}
  ${VTK_BINARY_DIR}/Parallel/Core/vtkSocketCommunicatorHash.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_BINARY_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/Common/Math
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/System
  ${VTK_SOURCE_DIR}/IO/Core
  ${VTK_SOURCE_DIR}/IO/Geometry
  ${VTK_SOURCE_DIR}/Utilities
  )

set_source_files_properties(
  vtkMultiProcessStream
  WRAP_EXCLUDE
  )

set_source_files_properties(
  vtkMultiProcessStream
  ABSTRACT
  )

vtk_add_library(vtkParallelCore ${Kit_SRCS})
