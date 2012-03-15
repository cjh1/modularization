add_executable(OpenGLTest test.cxx)

include_directories(
  ${VTK_SOURCE_DIR}/Interaction/Style
  ${VTK_BINARY_DIR}/Interaction/Style)

target_link_libraries(OpenGLTest vtkRenderingOpenGL vtkInteractionStyle)
