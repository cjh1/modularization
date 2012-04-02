# Default code to handle VTK module groups. The module.cmake files specify
# which groups the modules are in.
foreach(group ${VTK_GROUPS})
  message(STATUS "Group ${group} modules: ${VTK_GROUP_${group}_MODULES}")
  # Set the default group option - Rendeirng ON, and all others OFF.
  if(${group} MATCHES "^Rendering")
    set(_default ON)
  else()
    set(_default OFF)
  endif()
  option(VTK_GROUP_${group} "Request building ${group} modules" ${_default})
  # Now iterate through the modules, and request those that are depended on.
  if(VTK_GROUP_${group})
    foreach(module ${VTK_GROUP_${group}_MODULES})
      list(APPEND VTK_MODULE_${module}_REQUEST_BY VTK_GROUP_${group})
    endforeach()
  endif()
  # Hide the group options if building all modules.
  if(VTK_BUILD_ALL_MODULES)
    set_property(CACHE VTK_GROUP_${group} PROPERTY TYPE INTERNAL)
  else()
    set_property(CACHE VTK_GROUP_${group} PROPERTY TYPE BOOL)
  endif()
endforeach()
