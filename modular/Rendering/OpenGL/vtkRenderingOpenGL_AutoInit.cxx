#include "vtkRenderingOpenGLObjectFactory.h"

static unsigned int Count;
static vtkRenderingOpenGLObjectFactory* Factory;
struct vtkRenderingOpenGL_AutoInit
{
  vtkRenderingOpenGL_AutoInit();
  ~vtkRenderingOpenGL_AutoInit();
};
vtkRenderingOpenGL_AutoInit::vtkRenderingOpenGL_AutoInit()
{
  if(++Count == 1)
    {
    Factory = vtkRenderingOpenGLObjectFactory::New();
    vtkObjectFactory::RegisterFactory(Factory);
    }
}
vtkRenderingOpenGL_AutoInit::~vtkRenderingOpenGL_AutoInit()
{
  if(--Count == 0)
    {
    // Do not call vtkObjectFactory::UnRegisterFactory because
    // vtkObjectFactory.cxx statically unregisters all factories.
    Factory->Delete();
    }
}
