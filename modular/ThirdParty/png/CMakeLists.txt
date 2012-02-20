set(vtkpng_LIBRARIES vtkpng)
vtk_module_impl()
set(VTK_ZLIB_LIBRARIES ${vtkzlib_LIBRARIES})
add_subdirectory(vtkpng)
