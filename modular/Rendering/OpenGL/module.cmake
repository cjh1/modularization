vtk_module(vtkRenderingOpenGL
  GROUPS
    Rendering
    StandAlone
  IMPLEMENTS
    vtkRenderingCore
  DEPENDS
    # These are likely to be removed soon - split Rendering/OpenGL further.
    vtkRenderingFreeType # For vtkTextMapper
    vtkIOImage # For vtkImageExport
    vtkImagingHybrid # For vtkSampleFunction
  COMPILE_DEPENDS
    vtkParseOGLExt
    vtkUtilitiesEncodeString
  TEST_DEPENDS
    vtkInteractionStyle
    vtkTestingRendering
    vtkIOExport
    vtkRenderingLOD
    vtkImagingGeneral
    vtkImagingSources
  )
