vtk_module(vtkInteractionWidgets
  GROUPS
    Rendering
    StandAlone
  DEPENDS
    vtkRenderingAnnotation
    vtkRenderingFreeType
    vtkRenderingVolume
    vtkFiltersModeling
    vtkFiltersHybrid
    vtkImagingGeneral
    vtkInteractionStyle
  TEST_DEPENDS
    vtkTestingRendering
    vtkInteractionStyle
    vtkFiltersModeling
    vtkRenderingLOD
    vtkImagingStencil
  )
