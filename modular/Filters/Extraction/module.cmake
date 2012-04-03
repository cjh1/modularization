vtk_module(vtkFiltersExtraction
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonMisc
    vtkCommonTransforms
    vtkCommonMath
    vtkFiltersCore
    vtkFiltersGeneral
  TEST_DEPENDS
    vtkRenderingOpenGL
    vtkTestingRendering
    vtkInteractionStyle
  DEFAULT ON)
