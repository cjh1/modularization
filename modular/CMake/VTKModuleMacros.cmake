get_filename_component(_VTKModuleMacros_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

set(_VTKModuleMacros_DEFAULT_LABEL "VTKModular")

include(${_VTKModuleMacros_DIR}/VTKModuleAPI.cmake)

macro(vtk_module _name)
  vtk_module_check_name(${_name})
  set(vtk-module ${_name})
  set(vtk-module-test ${_name}-Test)
  set(_doing "")
  set(VTK_MODULE_${vtk-module}_DECLARED 1)
  set(VTK_MODULE_${vtk-module-test}_DECLARED 1)
  set(VTK_MODULE_${vtk-module}_DEPENDS "")
  set(VTK_MODULE_${vtk-module}_COMPILE_DEPENDS "")
  set(VTK_MODULE_${vtk-module-test}_DEPENDS "${vtk-module}")
  set(VTK_MODULE_${vtk-module}_DESCRIPTION "description")
  set(VTK_MODULE_${vtk-module}_EXCLUDE_FROM_ALL 0)
  foreach(arg ${ARGN})
    if("${arg}" MATCHES "^((|COMPILE_|TEST_|)DEPENDS|DESCRIPTION|DEFAULT)$")
      set(_doing "${arg}")
    elseif("${arg}" MATCHES "^EXCLUDE_FROM_ALL$")
      set(_doing "")
      set(VTK_MODULE_${vtk-module}_EXCLUDE_FROM_ALL 1)
    elseif("${arg}" MATCHES "^[A-Z][A-Z][A-Z]$" AND
           NOT "${arg}" MATCHES "^(ON|OFF)$")
      set(_doing "")
      message(AUTHOR_WARNING "Unknown argument [${arg}]")
    elseif("${_doing}" MATCHES "^DEPENDS$")
      list(APPEND VTK_MODULE_${vtk-module}_DEPENDS "${arg}")
    elseif("${_doing}" MATCHES "^TEST_DEPENDS$")
      list(APPEND VTK_MODULE_${vtk-module-test}_DEPENDS "${arg}")
    elseif("${_doing}" MATCHES "^COMPILE_DEPENDS$")
      list(APPEND VTK_MODULE_${vtk-module}_COMPILE_DEPENDS "${arg}")
    elseif("${_doing}" MATCHES "^DESCRIPTION$")
      set(_doing "")
      set(VTK_MODULE_${vtk-module}_DESCRIPTION "${arg}")
    elseif("${_doing}" MATCHES "^DEFAULT")
      #message(FATAL_ERROR "Invalid argument [DEFAULT]")
      # Ignore for now.
      set(_doing "")
    else()
      set(_doing "")
      message(AUTHOR_WARNING "Unknown argument [${arg}]")
    endif()
  endforeach()
  list(SORT VTK_MODULE_${vtk-module}_DEPENDS) # Deterministic order.
  set(VTK_MODULE_${vtk-module}_LINK_DEPENDS
    "${VTK_MODULE_${vtk-module}_DEPENDS}")
  list(APPEND VTK_MODULE_${vtk-module}_DEPENDS
    ${VTK_MODULE_${vtk-module}_COMPILE_DEPENDS})
  unset(VTK_MODULE_${vtk-module}_COMPILE_DEPENDS)
  list(SORT VTK_MODULE_${vtk-module}_DEPENDS) # Deterministic order.
  list(SORT VTK_MODULE_${vtk-module-test}_DEPENDS) # Deterministic order.
endmacro()

macro(vtk_module_check_name _name)
  if( NOT "${_name}" MATCHES "^[a-zA-Z][a-zA-Z0-9]*$")
    message(FATAL_ERROR "Invalid module name: ${_name}")
  endif()
endmacro()

macro(vtk_module_impl)
  include(module.cmake) # Load module meta-data

  vtk_module_use(${VTK_MODULE_${vtk-module}_DEPENDS})

  if(NOT DEFINED ${vtk-module}_LIBRARIES)
    set(${vtk-module}_LIBRARIES "")
    foreach(dep IN LISTS VTK_MODULE_${vtk-module}_LINK_DEPENDS)
      list(APPEND ${vtk-module}_LIBRARIES "${${dep}_LIBRARIES}")
    endforeach()
    if(${vtk-module}_LIBRARIES)
      list(REMOVE_DUPLICATES ${vtk-module}_LIBRARIES)
    endif()
  endif()

  list(APPEND ${vtk-module}_INCLUDE_DIRS
    ${${vtk-module}_BINARY_DIR}
    ${${vtk-module}_SOURCE_DIR}
    )
  #install(DIRECTORY include/ DESTINATION ${${vtk-module}_INSTALL_INCLUDE_DIR})

  if(${vtk-module}_INCLUDE_DIRS)
    include_directories(${${vtk-module}_INCLUDE_DIRS})
  endif()
  if(${vtk-module}_SYSTEM_INCLUDE_DIRS)
    include_directories(${${vtk-module}_SYSTEM_INCLUDE_DIRS})
  endif()

  if(${vtk-module}_SYSTEM_LIBRARY_DIRS)
    link_directories(${${vtk-module}_SYSTEM_LIBRARY_DIRS})
  endif()

  if(${vtk-module}_THIRD_PARTY)
    vtk_module_warnings_disable(C CXX)
  endif()

  set(vtk-module-DEPENDS "${VTK_MODULE_${vtk-module}_DEPENDS}")
  set(vtk-module-LIBRARIES "${${vtk-module}_LIBRARIES}")
  set(vtk-module-INCLUDE_DIRS-build "${${vtk-module}_INCLUDE_DIRS}")
  set(vtk-module-INCLUDE_DIRS-install "\${VTK_INSTALL_PREFIX}/${${vtk-module}_INSTALL_INCLUDE_DIR}")
  if(${vtk-module}_SYSTEM_INCLUDE_DIRS)
    list(APPEND vtk-module-INCLUDE_DIRS-build "${${vtk-module}_SYSTEM_INCLUDE_DIRS}")
    list(APPEND vtk-module-INCLUDE_DIRS-install "${${vtk-module}_SYSTEM_INCLUDE_DIRS}")
  endif()
  set(vtk-module-LIBRARY_DIRS "${${vtk-module}_SYSTEM_LIBRARY_DIRS}")
  set(vtk-module-INCLUDE_DIRS "${vtk-module-INCLUDE_DIRS-build}")
  configure_file(${_VTKModuleMacros_DIR}/VTKModuleInfo.cmake.in ${VTK_MODULES_DIR}/${vtk-module}.cmake @ONLY)
  set(vtk-module-INCLUDE_DIRS "${vtk-module-INCLUDE_DIRS-install}")
  configure_file(${_VTKModuleMacros_DIR}/VTKModuleInfo.cmake.in CMakeFiles/${vtk-module}.cmake @ONLY)
  install(FILES
    ${${vtk-module}_BINARY_DIR}/CMakeFiles/${vtk-module}.cmake
    DESTINATION ${VTK_INSTALL_PACKAGE_DIR}/Modules
    )
endmacro()

macro(vtk_module_test)
  include(../module.cmake) # Load module meta-data
  set(${vtk-module-test}_LIBRARIES "")
  vtk_module_use(${VTK_MODULE_${vtk-module-test}_DEPENDS})
  foreach(dep IN LISTS VTK_MODULE_${vtk-module-test}_DEPENDS)
    list(APPEND ${vtk-module-test}_LIBRARIES "${${dep}_LIBRARIES}")
  endforeach()
endmacro()

macro(vtk_module_warnings_disable)
  foreach(lang ${ARGN})
    if(MSVC)
      string(REGEX REPLACE "(^| )[/-]W[0-4]( |$)" " "
        CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -w")
    elseif(BORLAND)
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -w-")
    else()
      set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -w")
    endif()
  endforeach()
endmacro()

macro(vtk_target_label _target_name)
  if(vtk-module)
    set(_label ${vtk-module})
  else()
    set(_label ${_VTKModuleMacros_DEFAULT_LABEL})
  endif()
  set_property(TARGET ${_target_name} PROPERTY LABELS ${_label})
endmacro()

macro(vtk_target_name _name)
  set_property(TARGET ${_name} PROPERTY VERSION 1)
  set_property(TARGET ${_name} PROPERTY SOVERSION 1)
  if("${_name}" MATCHES "^[Vv][Tt][Kk]")
    set(_vtk "")
  else()
    set(_vtk "vtk")
    message(AUTHOR_WARNING "Target [${_name}] does not start in 'vtk'.")
  endif()
  set_property(TARGET ${_name} PROPERTY OUTPUT_NAME ${_vtk}${_name}-${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION})
endmacro()

macro(vtk_target_export _name)
  if(NOT VTK_INSTALL_NO_LIBRARIES)
    set_property(GLOBAL APPEND PROPERTY VTK_TARGETS ${_name})
  endif()
endmacro()

macro(vtk_target_install _name)
  if(NOT VTK_INSTALL_NO_LIBRARIES)
    install(TARGETS ${_name}
      EXPORT ${VTK_INSTALL_EXPORT_NAME}
      RUNTIME DESTINATION ${VTK_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
      LIBRARY DESTINATION ${VTK_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
      ARCHIVE DESTINATION ${VTK_INSTALL_ARCHIVE_DIR} COMPONENT Development
      )
  endif()
endmacro()

macro(vtk_target _name)
  set(_install 1)
  foreach(arg ${ARGN})
    if("${arg}" MATCHES "^(NO_INSTALL)$")
      set(_install 0)
    else()
      message(FATAL_ERROR "Unknown argument [${arg}]")
    endif()
  endforeach()
  vtk_target_name(${_name})
  vtk_target_label(${_name})
  vtk_target_export(${_name})
  if(_install)
    vtk_target_install(${_name})
  endif()
endmacro()

function(vtk_add_library name)
  add_library(${name} ${ARGN})
  vtk_target(${name})
endfunction()

function(vtk_add_executable name)
  if(UNIX AND VTK_BUILD_FORWARDING_EXECUTABLES)
    vtk_add_executable_with_forwarding(VTK_EXE_SUFFIX ${name} ${ARGN})
    set_property(GLOBAL APPEND PROPERTY VTK_TARGETS ${name})
  else()
    add_executable(${name} ${ARGN})
    set_property(GLOBAL APPEND PROPERTY VTK_TARGETS ${name})
  endif()
endfunction()

function(vtk_module_library name)
  if(NOT "${name}" STREQUAL "${vtk-module}")
    message(FATAL_ERROR "vtk_module_library must be invoked with module name")
  endif()

  set(${vtk-module}_LIBRARIES ${vtk-module})
  vtk_module_impl()

  vtk_add_library(${vtk-module} ${ARGN})
  foreach(dep IN LISTS VTK_MODULE_${vtk-module}_LINK_DEPENDS)
    target_link_libraries(${vtk-module} ${${dep}_LIBRARIES})
  endforeach()

  # Generate the export macro header for symbol visibility/Windows DLL declspec
  include(GenerateExportHeader)
  generate_export_header(${vtk-module} EXPORT_FILE_NAME ${vtk-module}Export.h)
  add_compiler_export_flags(my_abi_flags)
  set_property(TARGET ${vtk-module} APPEND
    PROPERTY COMPILE_FLAGS "${VTK_ABI_CXX_FLAGS}")
endfunction()
