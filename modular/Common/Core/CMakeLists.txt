set(KIT Common)

set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE})

if(WIN32)
  if(NOT VTK_USE_X)
    set(VTK_OWP_ENCODED_C vtkWin32OutputWindowProcessEncoded.c)
    set_source_files_properties(${VTK_OWP_ENCODED_C} PROPERTIES WRAP_EXCLUDE 1)
  endif()
endif()

if(UNIX)
  set(KIT_LIBS ${KIT_LIBS} ${CMAKE_THREAD_LIBS} ${CMAKE_DL_LIBS})
  set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE} -lm)
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
  ${VTK_SOURCE_DIR}/Utilities/utf8/source)

SET(Kit_SRCS
  vtkAbstractArray.cxx
  #vtkAnimationCue.cxx
  #vtkAnimationScene.cxx
  vtkArrayCoordinates.cxx
  vtkArray.cxx
  vtkArrayExtents.cxx
  vtkArrayExtentsList.cxx
  vtkArrayIterator.cxx
  vtkArrayRange.cxx
  vtkArraySort.cxx
  vtkArrayWeights.cxx
  vtkBitArray.cxx
  vtkBitArrayIterator.cxx
  vtkBoundingBox.cxx
  vtkBreakPoint.cxx
  vtkByteSwap.cxx
  vtkCallbackCommand.cxx
  vtkCharArray.cxx
  vtkCollection.cxx
  vtkCollectionIterator.cxx
  vtkCommand.cxx
  vtkCommonInformationKeyManager.cxx
  vtkCriticalSection.cxx
  vtkConditionVariable.cxx
  vtkDataArrayCollection.cxx
  vtkDataArrayCollectionIterator.cxx
  vtkDataArray.cxx
  vtkDataArraySelection.cxx
  vtkDebugLeaks.cxx
  vtkDebugLeaksManager.cxx
  vtkDoubleArray.cxx
  vtkDynamicLoader.cxx
  vtkEventForwarderCommand.cxx
  vtkFileOutputWindow.cxx
  vtkFloatArray.cxx
  vtkFloatingPointExceptions.cxx
  vtkGarbageCollector.cxx
  vtkGarbageCollectorManager.cxx
  vtkIdListCollection.cxx
  vtkIdList.cxx
  vtkIdTypeArray.cxx
  vtkIndent.cxx
  vtkInformation.cxx
#  vtkInformationDataObjectKey.cxx
  vtkInformationDoubleKey.cxx
  vtkInformationDoubleVectorKey.cxx
  vtkInformationIdTypeKey.cxx
  vtkInformationInformationKey.cxx
  vtkInformationInformationVectorKey.cxx
  vtkInformationIntegerKey.cxx
  vtkInformationIntegerPointerKey.cxx
  vtkInformationIntegerVectorKey.cxx
  vtkInformationIterator.cxx
  vtkInformationKey.cxx
  vtkInformationKeyVectorKey.cxx
  vtkInformationObjectBaseKey.cxx
  vtkInformationObjectBaseVectorKey.cxx
#  vtkInformationQuadratureSchemeDefinitionVectorKey.cxx
  vtkInformationRequestKey.cxx
  vtkInformationStringKey.cxx
  vtkInformationStringVectorKey.cxx
  vtkInformationUnsignedLongKey.cxx
  vtkInformationVector.cxx
  vtkInstantiator.cxx
#  vtk__Int64Array.cxx
  vtkIntArray.cxx
  vtkIOStream.cxx
  vtkLargeInteger.cxx
  vtkLongArray.cxx
  vtkLongLongArray.cxx
  vtkLookupTable.cxx
  vtkMath.cxx
  vtkMultiThreader.cxx
  vtkMutexLock.cxx
  vtkObjectBase.cxx
  vtkObject.cxx
  vtkObjectFactoryCollection.cxx
  vtkObjectFactory.cxx
  vtkOldStyleCallbackCommand.cxx
  vtkOStreamWrapper.cxx
  vtkOStrStreamWrapper.cxx
  vtkOutputWindow.cxx
  vtkOverrideInformationCollection.cxx
  vtkOverrideInformation.cxx
  vtkPriorityQueue.cxx
  vtkReferenceCount.cxx
  vtkScalarsToColors.cxx
  vtkShortArray.cxx
  vtkSignedCharArray.cxx
  vtkSmartPointerBase.cxx
  vtkSortDataArray.cxx
  vtkStdString.cxx
  vtkStringArray.cxx
  vtkTimePointUtility.cxx
  vtkTimeStamp.cxx
  vtkUnicodeStringArray.cxx
  vtkUnicodeString.cxx
  vtkUnsignedCharArray.cxx
#  vtkUnsigned__Int64Array.cxx
  vtkUnsignedIntArray.cxx
  vtkUnsignedLongArray.cxx
  vtkUnsignedLongLongArray.cxx
  vtkUnsignedShortArray.cxx
  vtkVariantArray.cxx
  vtkVariant.cxx
  vtkVersion.cxx
  vtkVoidArray.cxx
  vtkWeakPointerBase.cxx
  vtkWindow.cxx
  vtkXMLFileOutputWindow.cxx
  )

# Generate data for folding Unicode strings
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vtkUnicodeString.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/vtkUnicodeString.cmake @ONLY)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vtkConfigure.h.in
               ${VTK_BINARY_DIR}/vtkConfigure.h @ONLY IMMEDIATE)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vtkToolkits.h.in
               ${VTK_BINARY_DIR}/vtkToolkits.h @ONLY IMMEDIATE)

add_custom_command(
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/CaseFolding.txt
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/vtkUnicodeString.cmake
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/vtkUnicodeString.cmake
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/vtkUnicodeCaseFoldData.h
  )

set_source_files_properties(
  vtkUnicodeString.cxx
  OBJECT_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/vtkUnicodeCaseFoldData.h
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

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/vtkFloatingPointExceptionsConfigure.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/vtkFloatingPointExceptionsConfigure.h
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR})

# header files that have constants that can be wrapped
set(Kit_WRAP_HEADERS
  vtkSystemIncludes.h
  vtkType.h
  ${CMAKE_CURRENT_BINARY_DIR}/vtkMathConfigure.h
  ${VTK_BINARY_DIR}/vtkConfigure.h
  )

SET_SOURCE_FILES_PROPERTIES(
# vtkObjectBase is marked ABSTRACT so that instantiators are happy.
vtkAbstractArray
vtkArrayIterator
vtkArrayIteratorTemplate
vtkAbstractTransform
vtkArray
vtkCallbackCommand
vtkCommand
vtkCommonInformationKeyManager
vtkDataArray
vtkEventForwarderCommand
vtkFloatingPointExceptions
vtkFunctionSet
vtkGaussianRandomSequence
vtkHomogeneousTransform
vtkImplicitFunction
vtkInformationDataObjectKey
vtkInformationDoubleKey
vtkInformationDoubleVectorKey
vtkInformationIdTypeKey
vtkInformationInformationKey
vtkInformationInformationVectorKey
vtkInformationIntegerKey
vtkInformationIntegerPointerKey
vtkInformationIntegerVectorKey
vtkInformationKey
vtkInformationKeyVectorKey
vtkInformationObjectBaseKey
vtkInformationObjectBaseVectorKey
vtkInformationQuadratureSchemeDefinitionVectorKey
vtkInformationRequestKey
vtkInformationStringKey
vtkInformationStringVectorKey
vtkInformationUnsignedLongKey
vtkInitialValueProblemSolver
vtkLinearTransform
vtkObjectBase
vtkObjectFactory
vtkOldStyleCallbackCommand
vtkOverrideInformation
vtkOverrideInformationCollection
vtkParametricFunction
vtkProp
vtkRandomSequence
vtkScalarsToColors
vtkSocket
vtkStructuredData
vtkWarpTransform
vtkWindow
ABSTRACT
)

SET_SOURCE_FILES_PROPERTIES(
  vtkArrayCoordinates.cxx
  vtkArrayExtents.cxx
  vtkArrayExtentsList.cxx
  vtkArrayIteratorTemplate.txx
  vtkArrayRange.cxx
  vtkArraySort.cxx
  vtkArrayWeights.cxx
  vtkBoundingBox.cxx
  vtkBreakPoint.cxx
  vtkCallbackCommand.cxx
  vtkCommonInformationKeyManager.cxx
  vtkDebugLeaksManager.cxx
  vtkErrorCode.cxx
  vtkEventForwarderCommand.cxx
  vtkFloatingPointExceptions
  vtkGarbageCollectorManager.cxx
  vtkIOStream.cxx
  vtkIndent.cxx
  vtkLargeInteger.cxx
  vtkOStrStreamWrapper.cxx
  vtkOStreamWrapper.cxx
  vtkOldStyleCallbackCommand.cxx
  vtkSmartPointerBase.cxx
  vtkStdString.cxx
  vtkTimeStamp.cxx
  vtkVariant.cxx
  vtkWeakPointerBase.cxx
  vtkUnicodeString.cxx

  WRAP_EXCLUDE
)

SET_SOURCE_FILES_PROPERTIES(
  vtkArrayCoordinates.cxx
  vtkArrayExtents.cxx
  vtkArrayExtentsList.cxx
  vtkArrayRange.cxx
  vtkTimeStamp.cxx
  vtkVariant.cxx

  PROPERTIES WRAP_SPECIAL 1
)

# Activate code in "vtkVariant.cxx".  See the comment in the source.
SET_SOURCE_FILES_PROPERTIES(vtkVariant.cxx PROPERTIES
  COMPILE_FLAGS -DVTK_VARIANT_IMPL)

SET(Kit_EXTRA_SRCS)
SET(Kit_EXTRA_CMDS)
SET(Kit_TCL_EXTRA_SRCS vtkTclUtil.cxx)
SET(Kit_PYTHON_EXTRA_SRCS vtkPythonCommand.cxx)
SET(Kit_JAVA_EXTRA_SRCS vtkJavaUtil.cxx)
SET(KIT_TCL_DEPS)
SET(KIT_PYTHON_DEPS)
SET(KIT_JAVA_DEPS)

if(WIN32)
  if(NOT VTK_USE_X)
    list(APPEND Kit_SRCS vtkWin32OutputWindow.cxx
      vtkWin32ProcessOutputWindow.cxx)
    set(Kit_EXTRA_SRCS ${Kit_EXTRA_SRCS} vtkWin32OutputWindowProcessEncoded.c)
    set_source_files_properties(vtkWin32OutputWindowProcessEncoded.c
      PROPERTIES WRAP_EXCLUDE 1)
  endif()

  if(NOT BORLAND)
    set(KIT_LIBS ${KIT_LIBS} wsock32)
  endif()
endif()

if(NOT HAVE_SOCKETS)
  # Tell vtkSocket.cxx that there are no sockets on this platform.
  set_source_files_properties(vtkSocket.cxx PROPERTIES
    COMPILE_FLAGS -DVTK_SOCKET_FAKE_API)
endif()

# Need nsl to resolve gethostbyname on SunOS-5.8
# and socket also
if(CMAKE_SYSTEM MATCHES "SunOS.*")
  set(KIT_LIBS ${KIT_LIBS} socket nsl)
endif()

add_library(vtkCore ${Kit_SRCS})

IF(CMAKE_COMPILER_IS_GNUCXX AND MINGW)
  # MinGW fails to dllexport the explicit instantiations of
  # vtkDataArrayTemplate, so we must export all symbols.
  GET_TARGET_PROPERTY(VTK_COMMON_LINK_FLAGS vtkCommon LINK_FLAGS)
  IF(VTK_COMMON_LINK_FLAGS)
    SET(VTK_COMMON_LINK_FLAGS "${VTK_COMMON_LINK_FLAGS} ")
  ELSE(VTK_COMMON_LINK_FLAGS)
    SET(VTK_COMMON_LINK_FLAGS)
  ENDIF(VTK_COMMON_LINK_FLAGS)
  SET_TARGET_PROPERTIES(vtkCommon PROPERTIES
    LINK_FLAGS "${VTK_COMMON_LINK_FLAGS}-Wl,--export-all-symbols")
ENDIF(CMAKE_COMPILER_IS_GNUCXX AND MINGW)
