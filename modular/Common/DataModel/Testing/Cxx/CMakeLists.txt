create_test_sourcelist(Tests ${vtk-module}CxxTests.cxx
  TestVector.cxx
  TestVectorOperators.cxx
  TestAMRBox.cxx
  TestGenericCell.cxx
  TestGraph.cxx
  TestHigherOrderCell.cxx
  TestImageDataFindCell.cxx
  TestImageDataInterpolation.cxx
  TestImageIterator.cxx
  TestInterpolationDerivs.cxx
  TestInterpolationFunctions.cxx
  TestPointLocators.cxx
  TestPolyDataRemoveCell.cxx
  TestPolygon.cxx
  TestSelectionSubtract.cxx
  TestTreeBFSIterator.cxx
  TestTreeDFSIterator.cxx
  TestTriangle.cxx
  otherCellArray.cxx
  otherCellBoundaries.cxx
  otherCellPosition.cxx
  otherCellTypes.cxx
  otherColorTransferFunction.cxx
  otherEmptyCell.cxx
  otherFieldData.cxx
  otherRectilinearGrid.cxx
  otherStructuredGrid.cxx
  quadCellConsistency.cxx
  quadraticEvaluation.cxx
  TestBoundingBox.cxx
  TestPlane.cxx
  TestStructuredData.cxx
  EXTRA_INCLUDE vtkTestDriver.h
)

vtk_module_test_executable(${vtk-module}CxxTests ${Tests})

set(TestsToRun ${Tests})
list(REMOVE_ITEM TestsToRun ${vtk-module}CxxTests.cxx)

# Add all the executables
foreach (test ${TestsToRun})
  get_filename_component(TName ${test} NAME_WE)
  add_test(NAME ${vtk-module}Cxx-${TName}
    COMMAND ${vtk-module}CxxTests ${TName})
endforeach()
