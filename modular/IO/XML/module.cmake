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
    vtkImagingSources
    vtkFiltersSources
    vtkInfovisCore
    vtkFiltersCore
  DEFAULT ON)
