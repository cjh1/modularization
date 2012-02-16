set(Kit_SRCS
  vtkLabeledDataMapper.cxx
  vtkLabeledTreeMapDataMapper.cxx
  vtkLabelHierarchyAlgorithm.cxx
  vtkLabelHierarchyCompositeIterator.cxx
  vtkLabelHierarchy.cxx
  vtkLabelHierarchyIterator.cxx
  vtkLabelPlacementMapper.cxx
  vtkLabelPlacer.cxx
  vtkLabelRenderStrategy.cxx
  vtkLabelSizeCalculator.cxx
  vtkFreeTypeLabelRenderStrategy.cxx
  )

vtk_module_library(vtkRenderingLabel ${Kit_SRCS})
