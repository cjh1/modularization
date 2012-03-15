#include "vtkActor.h"
#include "vtkRenderWindow.h"
#include "vtkRenderWindowInteractor.h"
#include "vtkRenderer.h"
#include "vtkSphereSource.h"
#include "vtkConeSource.h"
#include "vtkPolyDataMapper.h"
#include "vtkProperty.h"
#include "vtkInteractorStyleTrackballCamera.h"
#include "vtkNew.h"

int main()
{
  vtkNew<vtkActor> actor;
  vtkNew<vtkRenderWindow> win;
  vtkNew<vtkRenderWindowInteractor> interactor;
  vtkNew<vtkRenderer> ren;
  vtkNew<vtkConeSource> sphere;
  vtkNew<vtkPolyDataMapper> mapper;
  vtkNew<vtkInteractorStyleTrackballCamera> style;
  /*
  cout << "vtkActor: " << actor->GetClassName() << endl;
  cout << "vtkRenderWindow: " << win->GetClassName() << endl;
  cout << "vtkRenderWindowInteractor: " << interactor->GetClassName() << endl;
  cout << "vtkRenderer: " << ren->GetClassName() << endl;
  cout << "vtkPolyDataMapper: " << mapper->GetClassName() << endl;
*/
//  sphere->SetThetaResolution(15);
//  sphere->SetPhiResolution(18);
  mapper->SetInputConnection(sphere->GetOutputPort());

  actor->SetMapper(mapper.GetPointer());
  actor->GetProperty()->SetColor(0, 0, 1);

  win->SetInteractor(interactor.GetPointer());
  win->AddRenderer(ren.GetPointer());

  win->SetSize(800, 600);
  ren->SetBackground(0, 0, 0);
  ren->AddActor(actor.GetPointer());

  interactor->SetInteractorStyle(style.GetPointer());
  interactor->Initialize();
  interactor->Start();

  return 0;
}
