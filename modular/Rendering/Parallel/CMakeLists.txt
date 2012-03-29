find_package(MPI)
include_directories(${MPI_INCLUDE_PATH})

set(Kit_SRCS
  vtkClientServerCompositePass.cxx
  vtkClientServerSynchronizedRenderers.cxx
  vtkCompositedSynchronizedRenderers.cxx
  vtkCompositer.cxx
  vtkCompositeRenderManager.cxx
  vtkCompositeRGBAPass.cxx
  # vtkCompositeZPass.cxx # fixme shaders
  #  vtkCompositeZPassShader_fs.glsl
  vtkCompressCompositer.cxx
  vtkParallelRenderManager.cxx
  vtkPHardwareSelector.cxx
  vtkSynchronizedRenderers.cxx
  vtkSynchronizedRenderWindows.cxx
  vtkTreeCompositer.cxx
  )

set_source_files_properties(
  vtkParallelRenderManager
  ABSTRACT
  )

vtk_module_library(vtkRenderingParallel ${Kit_SRCS})
