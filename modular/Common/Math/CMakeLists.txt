
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

add_library(vtkCommonMath ${Kit_SRCS})

target_link_libraries(vtkCommonMath vtkCommonCore)
