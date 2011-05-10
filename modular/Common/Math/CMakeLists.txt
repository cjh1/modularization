set(KIT Math)

set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE})

if(UNIX)
  set(KIT_LIBS ${KIT_LIBS} ${CMAKE_THREAD_LIBS} ${CMAKE_DL_LIBS})
  set(KIT_INTERFACE_LIBRARIES ${KWSYS_NAMESPACE} -lm)
endif()


SET(Kit_SRCS
  vtkAmoebaMinimizer.cxx
  vtkAmoebaMinimizer.h
  vtkFastNumericConversion.cxx
  vtkFastNumericConversion.h
  vtkFunctionSet.cxx
  vtkFunctionSet.h
  vtkInitialValueProblemSolver.cxx
  vtkInitialValueProblemSolver.h
  vtkMatrix3x3.cxx
  vtkMatrix3x3.h
  vtkMatrix4x4.cxx
  vtkMatrix4x4.h
  vtkPolynomialSolversUnivariate.cxx
  vtkPolynomialSolversUnivariate.h
  vtkQuaternionInterpolator.cxx
  vtkQuaternionInterpolator.h
  vtkRungeKutta2.cxx
  vtkRungeKutta2.h
  vtkRungeKutta45.cxx
  vtkRungeKutta45.h
  vtkRungeKutta4.cxx
  vtkRungeKutta4.h
  )

if(CMAKE_COMPILER_IS_GNUCXX)
  set_source_files_properties(
   vtkPolynomialSolversUnivariate.cxx
   PROPERTIES
   COMPILE_FLAGS -O0
   )
endif()


include_directories(${CMAKE_CURRENT_BINARY_DIR} ${VTK_SOURCE_DIR}/Common/Core)

#SET_SOURCE_FILES_PROPERTIES(
#ABSTRACT
#)

#SET_SOURCE_FILES_PROPERTIES(
#  WRAP_EXCLUDE
#)

#SET_SOURCE_FILES_PROPERTIES(
#  PROPERTIES WRAP_SPECIAL 1
#)

add_library(vtkMath ${Kit_SRCS})
