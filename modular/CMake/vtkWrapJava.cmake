#
# a cmake implementation of the Wrap Java command
#

MACRO(VTK_WRAP_JAVA2 TARGET SOURCE_LIST_NAME)
  # convert to the WRAP3 signature
  vtk_wrap_java3(${TARGET} ${SOURCE_LIST_NAME} "${ARGN}")
ENDMACRO(VTK_WRAP_JAVA2)

macro(vtk_wrap_java3 TARGET SRC_LIST_NAME SOURCES)
  IF(NOT VTK_PARSE_JAVA_EXE)
    MESSAGE(SEND_ERROR "VTK_PARSE_JAVA_EXE not specified when calling VTK_WRAP_JAVA3")
  ENDIF(NOT VTK_PARSE_JAVA_EXE)
  IF(NOT VTK_WRAP_JAVA_EXE)
    MESSAGE(SEND_ERROR "VTK_WRAP_JAVA_EXE not specified when calling VTK_WRAP_JAVA3")
  ENDIF(NOT VTK_WRAP_JAVA_EXE)

  IF(CMAKE_GENERATOR MATCHES "NMake Makefiles")
    SET(verbatim "")
    SET(quote "\"")
  ELSE(CMAKE_GENERATOR MATCHES "NMake Makefiles")
    SET(verbatim "VERBATIM")
    SET(quote "")
  ENDIF(CMAKE_GENERATOR MATCHES "NMake Makefiles")

  # Initialize the custom target counter.
  IF(VTK_WRAP_JAVA_NEED_CUSTOM_TARGETS)
    SET(VTK_WRAP_JAVA_CUSTOM_COUNT "")
    SET(VTK_WRAP_JAVA_CUSTOM_NAME ${TARGET})
    SET(VTK_WRAP_JAVA_CUSTOM_LIST)
  ENDIF(VTK_WRAP_JAVA_NEED_CUSTOM_TARGETS)

  GET_DIRECTORY_PROPERTY(TMP_DEF_LIST DEFINITION COMPILE_DEFINITIONS)
  SET(TMP_DEFINITIONS)
  FOREACH(TMP_DEF ${TMP_DEF_LIST})
    SET(TMP_DEFINITIONS ${TMP_DEFINITIONS} -D "${quote}${TMP_DEF}${quote}")
  ENDFOREACH(TMP_DEF ${TMP_DEF_LIST})

  IF(VTK_WRAP_INCLUDE_DIRS)
    SET(TMP_INCLUDE_DIRS ${VTK_WRAP_INCLUDE_DIRS})
  ELSE(VTK_WRAP_INCLUDE_DIRS)
    SET(TMP_INCLUDE_DIRS ${VTK_INCLUDE_DIRS})
  ENDIF(VTK_WRAP_INCLUDE_DIRS)
  SET(TMP_INCLUDE)
  FOREACH(INCLUDE_DIR ${TMP_INCLUDE_DIRS})
    SET(TMP_INCLUDE ${TMP_INCLUDE} -I "${quote}${INCLUDE_DIR}${quote}")
  ENDFOREACH(INCLUDE_DIR ${TMP_INCLUDE_DIRS})

  IF (VTK_WRAP_HINTS)
    SET(TMP_HINTS "--hints" "${quote}${VTK_WRAP_HINTS}${quote}")
  ELSE (VTK_WRAP_HINTS)
    SET(TMP_HINTS)
  ENDIF (VTK_WRAP_HINTS)
 
  IF (KIT_HIERARCHY_FILE)
    SET(TMP_HIERARCHY "--types" "${quote}${KIT_HIERARCHY_FILE}${quote}")
  ELSE (KIT_HIERARCHY_FILE)
    SET(TMP_HIERARCHY)
  ENDIF (KIT_HIERARCHY_FILE)

  SET(VTK_JAVA_DEPENDENCIES)
  SET(VTK_JAVA_DEPENDENCIES_FILE)
  # For each class
  FOREACH(FILE ${SOURCES})
    # should we wrap the file?
    get_source_file_property(TMP_WRAP_EXCLUDE ${FILE} WRAP_EXCLUDE)
    
    # we don't wrap the headers in Java
    get_source_file_property(TMP_WRAP_HEADER ${FILE} WRAP_HEADER)

    # if we should wrap it
    IF (NOT TMP_WRAP_EXCLUDE AND NOT TMP_WRAP_HEADER)

      # what is the filename without the extension
      GET_FILENAME_COMPONENT(TMP_FILENAME ${FILE} NAME_WE)

      # the input file might be full path so handle that
      GET_FILENAME_COMPONENT(TMP_FILEPATH ${FILE} PATH)

      # compute the input filename
      IF (TMP_FILEPATH)
        SET(TMP_INPUT ${TMP_FILEPATH}/${TMP_FILENAME}.h)
      ELSE (TMP_FILEPATH)
        SET(TMP_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/${TMP_FILENAME}.h)
      ENDIF (TMP_FILEPATH)

      # is it abstract?
      GET_SOURCE_FILE_PROPERTY(TMP_ABSTRACT ${FILE} ABSTRACT)
      IF (TMP_ABSTRACT)
        SET(TMP_CONCRETE "--abstract")
      ELSE (TMP_ABSTRACT)
        SET(TMP_CONCRETE "--concrete")
      ENDIF (TMP_ABSTRACT)

      # new source file is nameJava.cxx, add to resulting list
      SET(${SRC_LIST_NAME} ${${SRC_LIST_NAME}}
        ${TMP_FILENAME}Java.cxx)

      # add custom command to output
      ADD_CUSTOM_COMMAND(
        OUTPUT ${VTK_JAVA_HOME}/${TMP_FILENAME}.java
        DEPENDS ${VTK_PARSE_JAVA_EXE} ${VTK_WRAP_HINTS} ${TMP_INPUT}
        ${KIT_HIERARCHY_FILE}
        COMMAND ${VTK_PARSE_JAVA_EXE}
        ARGS
        ${TMP_CONCRETE}
        ${TMP_HINTS}
        ${TMP_HIERARCHY}
        ${TMP_DEFINITIONS}
        ${TMP_INCLUDE}
        "${quote}${TMP_INPUT}${quote}"
        "${quote}${VTK_JAVA_HOME}/${TMP_FILENAME}.java${quote}"
        COMMENT "Java Wrappings - generating ${TMP_FILENAME}.java"
        )

      # add custom command to output
      ADD_CUSTOM_COMMAND(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${TMP_FILENAME}Java.cxx
        DEPENDS ${VTK_WRAP_JAVA_EXE} ${VTK_WRAP_HINTS} ${TMP_INPUT}
        ${KIT_HIERARCHY_FILE}
        COMMAND ${VTK_WRAP_JAVA_EXE}
        ARGS
        ${TMP_CONCRETE}
        ${TMP_HINTS}
        ${TMP_HIERARCHY}
        ${TMP_DEFINITIONS}
        ${TMP_INCLUDE}
        "${quote}${TMP_INPUT}${quote}"
        "${quote}${CMAKE_CURRENT_BINARY_DIR}/${TMP_FILENAME}Java.cxx${quote}"
        COMMENT "Java Wrappings - generating ${TMP_FILENAME}Java.cxx"
        )

      SET(VTK_JAVA_DEPENDENCIES ${VTK_JAVA_DEPENDENCIES} "${VTK_JAVA_HOME}/${TMP_FILENAME}.java")
      SET(VTK_JAVA_DEPENDENCIES_FILE
        "${VTK_JAVA_DEPENDENCIES_FILE}\n  \"${VTK_JAVA_HOME}/${TMP_FILENAME}.java\"")

      # Add this output to a custom target if needed.
      IF(VTK_WRAP_JAVA_NEED_CUSTOM_TARGETS)
        SET(VTK_WRAP_JAVA_CUSTOM_LIST ${VTK_WRAP_JAVA_CUSTOM_LIST}
          ${CMAKE_CURRENT_BINARY_DIR}/${TMP_FILENAME}Java.cxx
          )
        SET(VTK_WRAP_JAVA_CUSTOM_COUNT ${VTK_WRAP_JAVA_CUSTOM_COUNT}x)
        IF(VTK_WRAP_JAVA_CUSTOM_COUNT MATCHES "^${VTK_WRAP_JAVA_CUSTOM_LIMIT}$")
          SET(VTK_WRAP_JAVA_CUSTOM_NAME ${VTK_WRAP_JAVA_CUSTOM_NAME}Hack)
          ADD_CUSTOM_TARGET(${VTK_WRAP_JAVA_CUSTOM_NAME} DEPENDS ${VTK_WRAP_JAVA_CUSTOM_LIST})
          SET(KIT_JAVA_DEPS ${VTK_WRAP_JAVA_CUSTOM_NAME})
          SET(VTK_WRAP_JAVA_CUSTOM_LIST)
          SET(VTK_WRAP_JAVA_CUSTOM_COUNT)
        ENDIF(VTK_WRAP_JAVA_CUSTOM_COUNT MATCHES "^${VTK_WRAP_JAVA_CUSTOM_LIMIT}$")
      ENDIF(VTK_WRAP_JAVA_NEED_CUSTOM_TARGETS)
    ENDIF ()
  ENDFOREACH(FILE)

  ADD_CUSTOM_TARGET("${TARGET}JavaClasses" ALL DEPENDS ${VTK_JAVA_DEPENDENCIES})
  SET(dir ${CMAKE_CURRENT_SOURCE_DIR})
  IF(VTK_WRAP_JAVA3_INIT_DIR)
    SET(dir ${VTK_WRAP_JAVA3_INIT_DIR})
  ENDIF(VTK_WRAP_JAVA3_INIT_DIR)
  CONFIGURE_FILE("${dir}/JavaDependencies.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/JavaDependencies.cmake" IMMEDIATE @ONLY)
endmacro()

# VS 6 does not like needing to run a huge number of custom commands
# when building a single target.  Generate some extra custom targets
# that run the custom commands before the main target is built.  This
# is a hack to work-around the limitation.  The test to enable it is
# done here since it does not need to be done for every macro
# invocation.
IF(CMAKE_GENERATOR MATCHES "^Visual Studio 6$")
  SET(VTK_WRAP_JAVA_NEED_CUSTOM_TARGETS 1)
  SET(VTK_WRAP_JAVA_CUSTOM_LIMIT x)
  # Limit the number of custom commands in each target
  # to 2^7.
  FOREACH(t 1 2 3 4 5 6 7)
    SET(VTK_WRAP_JAVA_CUSTOM_LIMIT
      ${VTK_WRAP_JAVA_CUSTOM_LIMIT}${VTK_WRAP_JAVA_CUSTOM_LIMIT})
  ENDFOREACH(t)
ENDIF(CMAKE_GENERATOR MATCHES "^Visual Studio 6$")


MACRO(VTK_GENERATE_JAVA_DEPENDENCIES TARGET)

  SET (javaPath "${VTK_BINARY_DIR}/java")
  IF (USER_JAVA_CLASSPATH)
    SET (javaPath "${USER_JAVA_PATH};${VTK_BINARY_DIR}/java")
  ENDIF (USER_JAVA_CLASSPATH)

  SET (OUT_TEXT)
  SET (sources)
  SET (driver)

  # get the classes for this lib
  FOREACH(srcName ${ARGN})
    
    # what is the filename without the extension
    GET_FILENAME_COMPONENT(srcNameWe ${srcName} NAME_WE)

    # the input file might be full path so handle that
    GET_FILENAME_COMPONENT(srcPath ${srcName} PATH)

    SET (className "${srcPath}/${srcNameWe}.class")
    SET (OUT_TEXT ${OUT_TEXT} "\n    dummy = new ${srcNameWe}()")
    SET (driver "${srcPath}/vtk${TARGET}Driver.class")
    SET (sources ${sources} ${srcName})
  ENDFOREACH(srcName)

  ADD_CUSTOM_COMMAND(
    OUTPUT ${driver}
    COMMAND "${JAVA_COMPILE}"
      -source 5 -classpath "${javaPath}" "${srcPath}/vtk${TARGET}Driver.java"
    DEPENDS ${sources}
    )
  ADD_CUSTOM_COMMAND(TARGET ${TARGET} SOURCE ${TARGET} DEPENDS ${driver})

  SET (TARGET_NAME ${TARGET})
  CONFIGURE_FILE(
    ${VTK_CMAKE_DIR}/vtkJavaDriver.java.in
    "${VTK_BINARY_DIR}/java/vtk/vtk${TARGET}Driver.java"
    COPY_ONLY
    IMMEDIATE
    )

ENDMACRO()
