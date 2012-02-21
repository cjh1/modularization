set(vtkfreetype_LIBRARIES vtkfreetype)
set(vtkfreetype_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/vtkfreetype/include)
vtk_module_impl()
add_subdirectory(vtkfreetype)
