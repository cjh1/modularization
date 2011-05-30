
SET(Kit_SRCS
vtkCardinalSpline.cxx
vtkCardinalSpline.h
vtkKochanekSpline.cxx
vtkKochanekSpline.h
vtkMeanValueCoordinatesInterpolator.cxx
vtkMeanValueCoordinatesInterpolator.h
vtkOrderedTriangulator.cxx
vtkOrderedTriangulator.h
vtkParametricBoy.cxx
vtkParametricBoy.h
vtkParametricConicSpiral.cxx
vtkParametricConicSpiral.h
vtkParametricCrossCap.cxx
vtkParametricCrossCap.h
vtkParametricDini.cxx
vtkParametricDini.h
vtkParametricEllipsoid.cxx
vtkParametricEllipsoid.h
vtkParametricEnneper.cxx
vtkParametricEnneper.h
vtkParametricFigure8Klein.cxx
vtkParametricFigure8Klein.h
vtkParametricFunction.cxx
vtkParametricFunction.h
vtkParametricKlein.cxx
vtkParametricKlein.h
vtkParametricMobius.cxx
vtkParametricMobius.h
vtkParametricRandomHills.cxx
vtkParametricRandomHills.h
vtkParametricRoman.cxx
vtkParametricRoman.h
vtkParametricSpline.cxx
vtkParametricSpline.h
vtkParametricSuperEllipsoid.cxx
vtkParametricSuperEllipsoid.h
vtkParametricSuperToroid.cxx
vtkParametricSuperToroid.h
vtkParametricTorus.cxx
vtkParametricTorus.h
  )

include_directories(
  ${CMAKE_CURRENT_BINARY_DIR} 
  ${VTK_SOURCE_DIR}/Common/Core
  ${VTK_SOURCE_DIR}/Common/DataModel
  ${VTK_SOURCE_DIR}/Common/Math
  ${VTK_SOURCE_DIR}/Common/Misc
  ${VTK_SOURCE_DIR}/Common/System
  )

#SET_SOURCE_FILES_PROPERTIES(
#ABSTRACT
#)

#SET_SOURCE_FILES_PROPERTIES(
#  WRAP_EXCLUDE
#)

#SET_SOURCE_FILES_PROPERTIES(
#  PROPERTIES WRAP_SPECIAL 1
#)

add_library(vtkCommonComputationalGeometry ${Kit_SRCS})

target_link_libraries(vtkCommonComputationalGeometry vtkCommonCore vtkCommonSystem vtkCommonMisc)
