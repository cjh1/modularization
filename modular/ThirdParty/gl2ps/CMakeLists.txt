vtk_module_impl()
configure_file(vtk_gl2ps.h.in vtk_gl2ps.h)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/vtk_gl2ps.h DESTINATION ${VTK_INSTALL_INCLUDE_DIR})
