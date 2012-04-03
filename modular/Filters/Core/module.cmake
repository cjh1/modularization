vtk_module(vtkFiltersCore
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkCommonSystem
    vtkCommonMisc
    vtkCommonTransforms
    vtkCommonMath
  TEST_DEPENDS
    vtkTestingRendering
    vtkIOXML
    vtkImagingCore
    vtkFiltersGeneral
    vtkRenderingOpenGL
  DEFAULT ON)
