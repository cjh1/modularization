set(Kit_SRCS
  vtkRRandomTableSource.cxx
  vtkRCalculatorFilter.cxx
  vtkRInterface.cxx
  vtkRAdapter.cxx
  vtkContingencyStatisticsGnuR.cxx
  vtkCorrelativeStatisticsGnuR.cxx
  vtkDescriptiveStatisticsGnuR.cxx
  vtkPCAStatisticsGnuR.cxx
)

find_package(R)
include_directories(${R_INCLUDE_DIR})

# Configure the module specific settings into a module configured header.
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vtkFiltersStatisticsGnuRConfigure.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/vtkFiltersStatisticsGnuRConfigure.h)

# Set up some of the module specific preprocessor definitions.
set(${vtk-module}_EXPORT_CODE "#include \"vtkFiltersStatisticsGnuRConfigure.h\"")

set_source_files_properties(
  vtkRAdapter.cxx
  WRAP_EXCLUDE
  )

vtk_module_library(vtkFiltersStatisticsGnuR ${Kit_SRCS})

target_link_libraries(vtkFiltersStatisticsGnuR ${R_LIBRARIES})
