set(Kit_SRCS
  vtkBSplineTransform.cxx
  vtkDepthSortPolyData.cxx
  vtkDSPFilterDefinition.cxx
  vtkDSPFilterGroup.cxx
  vtkEarthSource.cxx
  vtkFacetReader.cxx
  vtkGreedyTerrainDecimation.cxx
  vtkGridTransform.cxx
  vtkImageDataLIC2D.cxx
  vtkImageDataLIC2DExtentTranslator.cxx
  vtkImageToPolyDataFilter.cxx
  vtkImplicitModeller.cxx
  vtkPCAAnalysisFilter.cxx
  vtkPolyDataSilhouette.cxx
  vtkPolyDataToImageStencil.cxx
  vtkProcrustesAlignmentFilter.cxx
  vtkProjectedTerrainPath.cxx
  vtkRenderLargeImage.cxx
  vtkStructuredGridLIC2D.cxx
  vtkTemporalDataSetCache.cxx
  vtkTemporalInterpolator.cxx
  vtkTemporalShiftScale.cxx
  vtkTemporalSnapToTimeStep.cxx
  vtkTransformToGrid.cxx
  vtkWeightedTransformFilter.cxx
  vtkStructuredGridLIC2D_fs.cxx 
)

set(shader_files
  vtkStructuredGridLIC2D_fs.glsl
  )
# for vtkStructuredGridLIC2D
SET( shader_h_files )
FOREACH( file ${shader_files} )
 
  message("@@@@ file=${file}")
 
  GET_FILENAME_COMPONENT(file_we ${file} NAME_WE)
  SET( src ${CMAKE_CURRENT_SOURCE_DIR}/${file} )
  SET( res ${CMAKE_CURRENT_BINARY_DIR}/${file_we}.cxx )
  SET( resh ${CMAKE_CURRENT_BINARY_DIR}/${file_we}.h )
  SET( shader_h_files ${shader_h_files} "${resh}" )
  ADD_CUSTOM_COMMAND(
    OUTPUT ${res} ${resh}
    DEPENDS ${src} vtkEncodeString
    COMMAND ${VTK_ENCODESTRING_EXE}
    ARGS ${res} ${src} ${file_we} --build-header VTK_HYBRID_EXPORT vtkSystemIncludes.h
    )
  SET( Kit_EXTRA_SRCS ${Kit_EXTRA_SRCS} ${res} )
ENDFOREACH( file )

vtk_add_library(vtkFiltersHybrid ${Kit_SRCS})