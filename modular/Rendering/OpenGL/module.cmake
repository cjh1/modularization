vtk_module(vtkRenderingOpenGL
  GROUPS
    Rendering
  IMPLEMENTS
    vtkRenderingCore
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonMath
    vtkCommonTransforms
    vtkCommonSystem
    vtkFiltersCore
    vtkIOXML
    # These are likely to be removed soon - split Rendering/OpenGL further.
    vtkRenderingText # For vtkTextMapper
    vtkIOImage # For vtkImageExport
    vtkImagingCore # For vtkSampleFunction
  COMPILE_DEPENDS
    vtkParseOGLExt
    vtkUtilitiesEncodeString
  TEST_DEPENDS
    vtkRenderingText
    vtkInteractionStyle
    vtkTestingRendering
    vtkIOExport
    vtkRenderingLOD
  DEFAULT ON)
