vtk_module(vtkIOXML
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonSystem
    vtkCommonMisc
    vtkIOCore
    vtkIOGeometry
    vtkexpat
    vtksys
  TEST_DEPENDS
    vtkTestingCore
    vtkImagingCore
    vtkFiltersSources
    vtkFiltersCore
  DEFAULT ON)
