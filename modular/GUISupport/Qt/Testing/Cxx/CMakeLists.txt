# if we have rendering add the following tests
# add tests that do not require data
set(MyTests
  TestQtDebugLeaksView.cxx
  #TestQtInitialization.cxx # This class is in Rendering/Qt (move test?)
  TestQtSQLDatabase.cxx
  TestQtTableModelAdapter.cxx
  TestQtTreeModelAdapter.cxx
  )
if(VTK_USE_VIEWS)
  set(MyTests
    ${MyTests}
    TestVtkQtTableView.cxx
    )
endif()

create_test_sourcelist(Tests ${vtk-module}CxxTests.cxx ${MyTests}
  EXTRA_INCLUDE vtkTestDriver.h)

find_package(Qt4 REQUIRED)
include(${QT_USE_FILE})

vtk_module_test_executable(${vtk-module}CxxTests ${Tests} QTestApp.cxx)
target_link_libraries(${vtk-module}CxxTests QVTK)

set(TestsToRun ${Tests})
remove(TestsToRun ${vtk-module}CxxTests.cxx)

# Add all the executables
foreach(test ${TestsToRun})
  get_filename_component(TName ${test} NAME_WE)
  if(VTK_DATA_ROOT)
  add_test(NAME QVTK-${TName}
    COMMAND ${vtk-module}CxxTests ${TName}
      -D ${VTK_DATA_ROOT}
      -T ${VTK_BINARY_DIR}/Testing/Temporary
      -V Baseline/QVTK/${TName}.png)
  else()
  add_test(NAME QVTK-${TName} COMMAND ${vtk-module}CxxTests ${TName})
  endif()
endforeach()
