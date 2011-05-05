set(KIT Math)

set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE})

if(UNIX)
  set(KIT_LIBS ${KIT_LIBS} ${CMAKE_THREAD_LIBS} ${CMAKE_DL_LIBS})
  set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE} -lm)
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
  ${VTK_SOURCE_DIR}/Utilities/utf8/source)

SET(Kit_SRCS
  vtkAmoebaMinimizer.cxx:
  vtkAmoebaMinimizer.h:
  vtkFastNumericConversion.cxx:
  vtkFastNumericConversion.h:
  vtkFunctionSet.cxx:
  vtkFunctionSet.h:
  vtkInitialValueProblemSolver.cxx:
  vtkInitialValueProblemSolver.h:
  vtkMatrix3x3.cxx:
  vtkMatrix3x3.h:
  vtkMatrix4x4.cxx:
  vtkMatrix4x4.h:
  vtkPolynomialSolversUnivariate.cxx:
  vtkPolynomialSolversUnivariate.h:
  vtkQuaternionInterpolator.cxx:
  vtkQuaternionInterpolator.h:
  vtkRungeKutta2.cxx:
  vtkRungeKutta2.h:
  vtkRungeKutta45.cxx:
  vtkRungeKutta45.h:
  vtkRungeKutta4.cxx:
  vtkRungeKutta4.h:
  )

if(CMAKE_COMPILER_IS_GNUCXX)
  set_source_files_properties(
   vtkPolynomialSolversUnivariate.cxx
   PROPERTIES
   COMPILE_FLAGS -O0
   )
endif()

if(VTK_TYPE_USE_LONG_LONG)
  list(APPEND Kit_SRCS
    vtkLongLongArray.cxx
    vtkUnsignedLongLongArray.cxx
    )
endif()

if(VTK_TYPE_USE___INT64)
  list(APPEND Kit_SRCS vtk__Int64Array.cxx)
  if(VTK_TYPE_CONVERT_UI64_TO_DOUBLE)
    list(APPEND Kit_SRCS vtkUnsigned__Int64Array.cxx)
  endif()
endif()

# Configure data arrays for platform-independent fixed-size types.
# Match the type selection here to that in vtkType.h.
IF(VTK_TYPE_CHAR_IS_SIGNED)
  SET(VTK_TYPE_NATIVE_Int8 Char)
ELSE(VTK_TYPE_CHAR_IS_SIGNED)
  SET(VTK_TYPE_NATIVE_Int8 SignedChar)
ENDIF(VTK_TYPE_CHAR_IS_SIGNED)
SET(VTK_TYPE_NATIVE_Int16 Short)
SET(VTK_TYPE_NATIVE_Int32 Int)
SET(VTK_TYPE_NATIVE_UInt8 UnsignedChar)
SET(VTK_TYPE_NATIVE_UInt16 UnsignedShort)
SET(VTK_TYPE_NATIVE_UInt32 UnsignedInt)

IF(VTK_SIZEOF_LONG_LONG MATCHES "^8$")
  SET(VTK_TYPE_NATIVE_Int64 LongLong)
  SET(VTK_TYPE_NATIVE_UInt64 UnsignedLongLong)
ELSE(VTK_SIZEOF_LONG_LONG MATCHES "^8$")
  IF(VTK_SIZEOF_LONG MATCHES "^8$")
    SET(VTK_TYPE_NATIVE_Int64 Long)
    SET(VTK_TYPE_NATIVE_UInt64 UnsignedLong)
  ELSE(VTK_SIZEOF_LONG MATCHES "^8$")
    IF(VTK_SIZEOF___INT64 MATCHES "^8$")
      SET(VTK_TYPE_NATIVE_Int64 __Int64)
      IF(VTK_TYPE_CONVERT_UI64_TO_DOUBLE)
        SET(VTK_TYPE_NATIVE_UInt64 Unsigned__Int64)
      ENDIF(VTK_TYPE_CONVERT_UI64_TO_DOUBLE)
    ENDIF(VTK_SIZEOF___INT64 MATCHES "^8$")
  ENDIF(VTK_SIZEOF_LONG MATCHES "^8$")
ENDIF(VTK_SIZEOF_LONG_LONG MATCHES "^8$")
SET(VTK_TYPE_NATIVE_Float32 Float)
SET(VTK_TYPE_NATIVE_Float64 Double)
FOREACH(t Int8 Int16 Int32 Int64 UInt8 UInt16 UInt32 UInt64 Float32 Float64)
  SET(VTK_TYPE_NAME ${t})
  SET(VTK_TYPE_NATIVE ${VTK_TYPE_NATIVE_${t}})
  IF(VTK_TYPE_NATIVE)
    CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/vtkTypedArray.h.in
                   ${CMAKE_CURRENT_BINARY_DIR}/vtkType${t}Array.h
                   @ONLY IMMEDIATE)
    CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/vtkTypedArray.cxx.in
                   ${CMAKE_CURRENT_BINARY_DIR}/vtkType${t}Array.cxx
                   @ONLY IMMEDIATE)
    SET(Kit_SRCS ${Kit_SRCS} ${CMAKE_CURRENT_BINARY_DIR}/vtkType${t}Array.cxx)
  ENDIF(VTK_TYPE_NATIVE)
ENDFOREACH(t)

# Figure out if isnan and isinf functions are present.
include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckIncludeFile)

if(NOT HAVE_FLOAT_H)
  CHECK_INCLUDE_FILE("float.h" HAVE_FLOAT_H)
endif()

if(HAVE_FLOAT_H)
  CHECK_SYMBOL_EXISTS(isnan "float.h" VTK_HAS_ISNAN)
  if(NOT VTK_HAS_ISNAN)
    CHECK_SYMBOL_EXISTS(_isnan "float.h" VTK_HAS__ISNAN)
  endif()
  CHECK_SYMBOL_EXISTS(isinf "float.h" VTK_HAS_ISINF)
  if(NOT VTK_HAS_ISINF)
    CHECK_FUNCTION_EXISTS(_isinf "float.h" VTK_HAS__ISINF)
  endif()
endif()

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/vtkMathConfigure.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/vtkMathConfigure.h
  )

# Figure out if feenableexcept and fedisableexcept functions are present
CHECK_INCLUDE_FILE("fenv.h" HAVE_FENV_H)
IF (HAVE_FENV_H)
  SET(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)
  IF(UNIX)
    SET(CMAKE_REQUIRED_LIBRARIES m)
  ENDIF(UNIX)
  CHECK_SYMBOL_EXISTS(feenableexcept "fenv.h" VTK_HAS_FEENABLEEXCEPT)
  SET(CMAKE_REQUIRED_LIBRARIES)
ENDIF (HAVE_FENV_H)

#configure_file(
#  ${CMAKE_CURRENT_SOURCE_DIR}/vtkFloatingPointExceptionsConfigure.h.in
#  ${CMAKE_CURRENT_BINARY_DIR}/vtkFloatingPointExceptionsConfigure.h
#  )

include_directories(${CMAKE_CURRENT_BINARY_DIR})

#SET_SOURCE_FILES_PROPERTIES(
#ABSTRACT
#)

#SET_SOURCE_FILES_PROPERTIES(
#  WRAP_EXCLUDE
#)

#SET_SOURCE_FILES_PROPERTIES(
#  PROPERTIES WRAP_SPECIAL 1
#)

# Activate code in "vtkVariant.cxx".  See the comment in the source.
#SET_SOURCE_FILES_PROPERTIES(vtkVariant.cxx PROPERTIES
#  COMPILE_FLAGS -DVTK_VARIANT_IMPL)

add_library(vtkMath ${Kit_SRCS})
