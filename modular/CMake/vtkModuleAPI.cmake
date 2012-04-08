

#-----------------------------------------------------------------------------
# Private helper macros.

macro(_vtk_module_config_recurse ns mod)
  if(NOT _${ns}_${dep}_USED)
    set(_${ns}_${mod}_USED 1)
    vtk_module_load("${mod}")
    list(APPEND ${ns}_LIBRARIES ${${mod}_LIBRARIES})
    list(APPEND ${ns}_INCLUDE_DIRS ${${mod}_INCLUDE_DIRS})
    list(APPEND ${ns}_LIBRARY_DIRS ${${mod}_LIBRARY_DIRS})
    foreach(iface IN LISTS ${mod}_IMPLEMENTS)
      list(APPEND _${ns}_AUTOINIT_${iface} ${mod})
      list(APPEND _${ns}_AUTOINIT ${iface})
    endforeach()
    foreach(dep IN LISTS ${mod}_DEPENDS)
      _vtk_module_config_recurse("${ns}" "${dep}")
    endforeach()
  endif()
endmacro()

#-----------------------------------------------------------------------------
# Public interface macros.

# vtk_module_load(<module>)
#
# Loads variables describing the given module:
#  <module>_LOADED         = True if the module has been loaded
#  <module>_DEPENDS        = List of dependencies on other modules
#  <module>_LIBRARIES      = Libraries to link
#  <module>_INCLUDE_DIRS   = Header search path
#  <module>_LIBRARY_DIRS   = Library search path (for outside dependencies)
macro(vtk_module_load mod)
  if(NOT ${mod}_LOADED)
    include("${VTK_MODULES_DIR}/${mod}.cmake" OPTIONAL)
    if(NOT ${mod}_LOADED)
      message(FATAL_ERROR "No such module: \"${mod}\"")
    endif()
  endif()
endmacro()

# vtk_module_config(<namespace> [modules...])
#
# Configures variables describing the given modules and their dependencies:
#  <namespace>_DEFINITIONS  = Preprocessor definitions
#  <namespace>_LIBRARIES    = Libraries to link
#  <namespace>_INCLUDE_DIRS = Header search path
#  <namespace>_LIBRARY_DIRS = Library search path (for outside dependencies)
# Do not name a module as the namespace.
macro(vtk_module_config ns)
  set(${ns}_DEFINITIONS "")
  set(${ns}_LIBRARIES "")
  set(${ns}_INCLUDE_DIRS "")
  set(${ns}_LIBRARY_DIRS "")
  set(_${ns}_AUTOINIT "")
  foreach(mod ${ARGN})
    _vtk_module_config_recurse("${ns}" "${mod}")
  endforeach()
  foreach(v ${ns}_LIBRARIES ${ns}_INCLUDE_DIRS ${ns}_LIBRARY_DIRS
           _${ns}_AUTOINIT)
    if(${v})
      list(REMOVE_DUPLICATES ${v})
    endif()
  endforeach()

  list(SORT _${ns}_AUTOINIT) # Deterministic order.
  foreach(mod ${_${ns}_AUTOINIT})
    list(SORT _${ns}_AUTOINIT_${mod}) # Deterministic order.
    list(LENGTH _${ns}_AUTOINIT_${mod} _ai_len)
    string(REPLACE ";" "," _ai "${_ai_len}(${_${ns}_AUTOINIT_${mod}})")
    if(${_ai_len} GREATER 1 AND "${CMAKE_GENERATOR}" MATCHES "Visual Studio")
      # VS IDE project files cannot handle a comma (,) in a
      # preprocessor definition value outside a quoted string.
      # Generate a header file to do the definition and define
      # ${mod}_INCLUDE to tell ${mod}Module.h to include it.
      # Name the file after its content to guarantee uniqueness.
      string(REPLACE ";" "_" _inc
        "${CMAKE_BINARY_DIR}/CMakeFiles/${mod}_AUTOINIT_${_${ns}_AUTOINIT_${mod}}.h")
      set(CMAKE_CONFIGURABLE_FILE_CONTENT "#define ${mod}_AUTOINIT ${_ai}")
      configure_file(${CMAKE_ROOT}/Modules/CMakeConfigurableFile.in ${_inc})
      list(APPEND ${ns}_DEFINITIONS "${mod}_INCLUDE=\"${_inc}\"")
    else()
      # Directly define ${mod}_AUTOINIT.
      list(APPEND ${ns}_DEFINITIONS "${mod}_AUTOINIT=${_ai}")
    endif()
    unset(_${ns}_AUTOINIT_${mod})
  endforeach()
  unset(_${ns}_AUTOINIT)
endmacro()
