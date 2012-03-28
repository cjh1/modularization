vtk_module(vtkChartsCore
  DEPENDS
    vtkRenderingContext2D
    vtkInfovisCore # Needed for plot parallel coordinates vtkStringToCategory
    vtkViewsInfovis # Needed for vtkRenderView
  TEST_DEPENDS
    vtkTestingCore
    vtkTestingRendering
    vtkViewsContext2D
    vtkIOInfovis
  DEFAULT ON)
