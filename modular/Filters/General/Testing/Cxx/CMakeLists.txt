set(MyTests
  TestGraphWeightEuclideanDistanceFilter.cxx
  BoxClipPolyData.cxx
  BoxClipTetrahedra.cxx
  BoxClipTriangulate.cxx
  BoxClipTriangulateAndInterpolate.cxx
  # TestBSPTree.cxx               # todo (unsatistfied deps)
  TestBooleanOperationPolyDataFilter.cxx
  TestBooleanOperationPolyDataFilter2.cxx
  TestDensifyPolyData.cxx
  TestDistancePolyDataFilter.cxx
  TestGradientAndVorticity.cxx
  TestIconGlyphFilterGravity.cxx
  TestImageDataToPointSet.cxx
  TestIntersectionPolyDataFilter.cxx
  # TestMultiBlock.cxx            # todo (unsatistfied deps)
  TestQuadraturePoints.cxx
  TestRectilinearGridToPointSet.cxx
  TestReflectionFilter.cxx
  TestUncertaintyTubeFilter.cxx
  TestYoungsMaterialInterface.cxx
)

# Use the testing object factory, to reduce boilerplate code in tests.
include("${VTK_SOURCE_DIR}/Testing/Rendering/vtkTestingObjectFactory.cmake")

vtk_module_test_executable(${vtk-module}CxxTests ${Tests})

set(TestsToRun ${Tests})
list(REMOVE_ITEM TestsToRun CxxTests.cxx)

# Add all the executables
foreach (test ${TestsToRun})
  get_filename_component(TName ${test} NAME_WE)
  
  if(VTK_DATA_ROOT)
  add_test(NAME ${vtk-module}Cxx-${TName}
    COMMAND ${vtk-module}CxxTests ${TName}
        -D ${VTK_DATA_ROOT}
        -T ${VTK_BINARY_DIR}/Testing/Temporary
        -V Baseline/Graphics/${TName}.png)
  else()
  add_test(NAME ${vtk-module}Cxx-${TName}
    COMMAND ${vtk-module}CxxTests ${TName}
      -T ${VTK_BINARY_DIR}/Testing/Temporary
      )
  endif()
endforeach()
