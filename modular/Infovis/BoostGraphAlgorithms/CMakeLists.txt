set(Kit_SRCS
  vtkBoostBetweennessClustering.cxx
  vtkBoostBiconnectedComponents.cxx
  vtkBoostBrandesCentrality.cxx
  vtkBoostBreadthFirstSearch.cxx
  vtkBoostBreadthFirstSearchTree.cxx
  vtkBoostConnectedComponents.cxx
  vtkBoostExtractLargestComponent.cxx
  vtkBoostKruskalMinimumSpanningTree.cxx
  vtkBoostLogWeighting.cxx
  vtkBoostPrimMinimumSpanningTree.cxx
  vtkBoostRandomSparseArraySource.cxx
  vtkBoostSplitTableField.cxx  
  )

find_package(Boost REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

vtk_module_library(vtkInfovisBoostGraphAlgorithms ${Kit_SRCS})
