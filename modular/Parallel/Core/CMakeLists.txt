
SET(Kit_SRCS
  vtkCommunicator.cxx
  vtkCommunicator.h
  vtkDummyCommunicator.cxx
  vtkDummyCommunicator.h
  vtkDummyController.cxx
  vtkDummyController.h
  vtkMultiProcessController.cxx
  vtkMultiProcessController.h
  vtkMultiProcessStream.cxx
  vtkMultiProcessStream.h
#  vtkParallelFactory.cxx
#  vtkParallelFactory.h
  vtkProcess.cxx
  vtkProcess.h
  vtkProcessGroup.cxx
  vtkProcessGroup.h
  vtkSocketCommunicator.cxx
  vtkSocketCommunicator.h
  vtkSocketController.cxx
  vtkSocketController.h
  vtkSubCommunicator.cxx
  vtkSubCommunicator.h
  vtkSubGroup.cxx
  vtkSubGroup.h
  )

# Generate "vtkSocketCommunicatorHash.h".
ADD_CUSTOM_COMMAND(
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

add_library(vtkParallelCore ${Kit_SRCS})

target_link_libraries(vtkParallelCore vtkCommonDataModel vtkIOGeometry)
