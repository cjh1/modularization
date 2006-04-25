/*=========================================================================

  Program:   Visualization Toolkit
  Module:    vtkBiQuadraticQuad.cxx

  Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
  All rights reserved.
  See Copyright.txt or http://www.kitware.com/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/

//Thanks to Soeren Gebbert  who developed this class and
//integrated it into VTK 5.0.

#include "vtkBiQuadraticQuad.h"

#include "vtkObjectFactory.h"
#include "vtkDoubleArray.h"
#include "vtkMath.h"
#include "vtkPointData.h"
#include "vtkQuad.h"
#include "vtkQuadraticEdge.h"

vtkCxxRevisionMacro(vtkBiQuadraticQuad, "1.2");
vtkStandardNewMacro(vtkBiQuadraticQuad);

//----------------------------------------------------------------------------
// Construct the quad with nine points.
vtkBiQuadraticQuad::vtkBiQuadraticQuad()
{
  this->Edge = vtkQuadraticEdge::New();
  this->Quad = vtkQuad::New();
  this->Points->SetNumberOfPoints(9);
  this->PointIds->SetNumberOfIds(9);
  this->Scalars = vtkDoubleArray::New();
  this->Scalars->SetNumberOfTuples(4);
}

//----------------------------------------------------------------------------
vtkBiQuadraticQuad::~vtkBiQuadraticQuad()
{
  this->Edge->Delete();
  this->Quad->Delete();

  this->Scalars->Delete();
}

//----------------------------------------------------------------------------
vtkCell *vtkBiQuadraticQuad::GetEdge(int edgeId)
{
  edgeId = (edgeId < 0 ? 0 : (edgeId > 3 ? 3 : edgeId));
  int p = (edgeId + 1) % 4;

  // load point id's
  this->Edge->PointIds->SetId (0, this->PointIds->GetId(edgeId));
  this->Edge->PointIds->SetId (1, this->PointIds->GetId(p));
  this->Edge->PointIds->SetId (2, this->PointIds->GetId(edgeId + 4));

  // load coordinates
  this->Edge->Points->SetPoint (0, this->Points->GetPoint(edgeId));
  this->Edge->Points->SetPoint (1, this->Points->GetPoint(p));
  this->Edge->Points->SetPoint (2, this->Points->GetPoint(edgeId + 4));

  return this->Edge;
}

//----------------------------------------------------------------------------
static int LinearQuads[4][4] = { {0, 4, 8, 7}, {8, 4, 1, 5},
                                 {8, 5, 2, 6}, {7, 8, 6, 3} };

//----------------------------------------------------------------------------
int vtkBiQuadraticQuad::EvaluatePosition (double *x,
                                          double *closestPoint,
                                          int &subId, double pcoords[3],
                                          double &minDist2, double *weights)
{
  double pc[3], dist2;
  int ignoreId, i, returnStatus = 0, status;
  double tempWeights[4];
  double closest[3];

  //four linear quads are used
  for (minDist2 = VTK_DOUBLE_MAX, i = 0; i < 4; i++)
    {
    this->Quad->Points->SetPoint (0,
      this->Points->GetPoint (LinearQuads[i][0]));
    this->Quad->Points->SetPoint (1,
      this->Points->GetPoint (LinearQuads[i][1]));
    this->Quad->Points->SetPoint (2,
      this->Points->GetPoint (LinearQuads[i][2]));
    this->Quad->Points->SetPoint (3,
      this->Points->GetPoint (LinearQuads[i][3]));

    status = this->Quad->EvaluatePosition (x, closest, ignoreId, pc, dist2,
      tempWeights);
    if (status != -1 && dist2 < minDist2)
      {
      returnStatus = status;
      minDist2 = dist2;
      subId = i;
      pcoords[0] = pc[0];
      pcoords[1] = pc[1];
      }
    }

  // adjust parametric coordinates
  if (returnStatus != -1)
    {
    if (subId == 0)
      {
      pcoords[0] /= 2.0;
      pcoords[1] /= 2.0;
      }
    else if (subId == 1)
      {
      pcoords[0] = 0.5 + (pcoords[0] / 2.0);
      pcoords[1] /= 2.0;
      }
    else if (subId == 2)
      {
      pcoords[0] = 0.5 + (pcoords[0] / 2.0);
      pcoords[1] = 0.5 + (pcoords[1] / 2.0);
      }
    else
      {
      pcoords[0] /= 2.0;
      pcoords[1] = 0.5 + (pcoords[1] / 2.0);
      }
    pcoords[2] = 0.0;
    this->EvaluateLocation (subId, pcoords, closestPoint, weights);
    }

  return returnStatus;
}

//----------------------------------------------------------------------------
void vtkBiQuadraticQuad::EvaluateLocation (int& vtkNotUsed(subId),
                                           double pcoords[3],
                                           double x[3], double *weights)
{
  int i, j;
  double *p = ((vtkDoubleArray *)this->Points->GetData())->GetPointer(0);

  this->InterpolationFunctions(pcoords,weights);

  for (j=0; j<3; j++)
    {
    x[j] = 0.0;
    for (i = 0; i < 8; i++)
      {
      x[j] += p[3*i+j] * weights[i];
      }
    }
}

//----------------------------------------------------------------------------
int vtkBiQuadraticQuad::CellBoundary (int subId, double pcoords[3], vtkIdList * pts)
{
  return this->Quad->CellBoundary (subId, pcoords, pts);
}


//----------------------------------------------------------------------------
void
vtkBiQuadraticQuad::Contour (double value,
           vtkDataArray *cellScalars,
           vtkPointLocator * locator,
           vtkCellArray * verts,
           vtkCellArray * lines,
           vtkCellArray * polys,
           vtkPointData * inPd,
           vtkPointData * outPd, vtkCellData * inCd, vtkIdType cellId, vtkCellData * outCd)
{
  //contour each linear quad separately
  for (int i=0; i<4; i++)
    {
    for (int j=0; j<4; j++)
      {
      this->Quad->Points->SetPoint(j,this->Points->GetPoint(LinearQuads[i][j]));
      this->Quad->PointIds->SetId(j,LinearQuads[i][j]);
      this->Scalars->SetValue(j,cellScalars->GetTuple1(LinearQuads[i][j]));
      }

    this->Quad->Contour(value,this->Scalars,locator,verts,lines,polys,
                        inPd,outPd,inCd,cellId,outCd);
    }
}

//----------------------------------------------------------------------------
// Clip this quadratic quad using scalar value provided. Like contouring, 
// except that it cuts the quad to produce other quads and triangles.
void
vtkBiQuadraticQuad::Clip (double value, vtkDataArray * cellScalars,
        vtkPointLocator * locator, vtkCellArray * polys,
        vtkPointData * inPd, vtkPointData * outPd,
        vtkCellData * inCd, vtkIdType cellId, vtkCellData * outCd, int insideOut)
{
  //contour each linear quad separately
  for (int i=0; i<4; i++)
    {
    for ( int j=0; j<4; j++) //for each of the four vertices of the linear quad
      {
      this->Quad->Points->SetPoint(j,this->Points->GetPoint(LinearQuads[i][j]));
      this->Quad->PointIds->SetId(j,LinearQuads[i][j]);
      this->Scalars->SetValue(j,cellScalars->GetTuple1(LinearQuads[i][j]));
      }

    this->Quad->Clip(value,this->Scalars,locator,polys,inPd,
                     outPd,inCd,cellId,outCd,insideOut);
    }
}

//----------------------------------------------------------------------------
// Line-line intersection. Intersection has to occur within [0,1] parametric
// coordinates and with specified tolerance.
int
vtkBiQuadraticQuad::IntersectWithLine (double *p1,
               double *p2, double tol, double &t, double *x, double *pcoords, int &subId)
{
  int subTest, i;
  subId = 0;

  //intersect the four linear quads
  for (i = 0; i < 4; i++)
    {
    this->Quad->Points->SetPoint (0,
      this->Points->GetPoint(LinearQuads[i][0]));
    this->Quad->Points->SetPoint (1,
      this->Points->GetPoint(LinearQuads[i][1]));
    this->Quad->Points->SetPoint (2,
      this->Points->GetPoint(LinearQuads[i][2]));
    this->Quad->Points->SetPoint (3,
      this->Points->GetPoint(LinearQuads[i][3]));

    if (this->Quad->IntersectWithLine (p1, p2, tol, t, x, pcoords, subTest))
      {
      return 1;
      }
    }

  return 0;
}

//----------------------------------------------------------------------------
int
vtkBiQuadraticQuad::Triangulate (int vtkNotUsed (index), vtkIdList * ptIds, vtkPoints * pts)
{
  pts->Reset ();
  ptIds->Reset ();

  // First the corner vertices
  ptIds->InsertId(0,this->PointIds->GetId(0));
  ptIds->InsertId(1,this->PointIds->GetId(4));
  ptIds->InsertId(2,this->PointIds->GetId(7));
  pts->InsertPoint(0,this->Points->GetPoint(0));
  pts->InsertPoint(1,this->Points->GetPoint(4));
  pts->InsertPoint(2,this->Points->GetPoint(7));

  ptIds->InsertId(3,this->PointIds->GetId(4));
  ptIds->InsertId(4,this->PointIds->GetId(1));
  ptIds->InsertId(5,this->PointIds->GetId(5));
  pts->InsertPoint(3,this->Points->GetPoint(4));
  pts->InsertPoint(4,this->Points->GetPoint(1));
  pts->InsertPoint(5,this->Points->GetPoint(5));

  ptIds->InsertId(6,this->PointIds->GetId(5));
  ptIds->InsertId(7,this->PointIds->GetId(2));
  ptIds->InsertId(8,this->PointIds->GetId(6));
  pts->InsertPoint(6,this->Points->GetPoint(5));
  pts->InsertPoint(7,this->Points->GetPoint(2));
  pts->InsertPoint(8,this->Points->GetPoint(6));

  ptIds->InsertId(9,this->PointIds->GetId(6));
  ptIds->InsertId(10,this->PointIds->GetId(3));
  ptIds->InsertId(11,this->PointIds->GetId(7));
  pts->InsertPoint(9,this->Points->GetPoint(6));
  pts->InsertPoint(10,this->Points->GetPoint(3));
  pts->InsertPoint(11,this->Points->GetPoint(7));

  //Now the triangles in the middle
  ptIds->InsertId(12,this->PointIds->GetId(8));
  ptIds->InsertId(13,this->PointIds->GetId(4));
  ptIds->InsertId(14,this->PointIds->GetId(7));
  pts->InsertPoint(12,this->Points->GetPoint(8));
  pts->InsertPoint(13,this->Points->GetPoint(4));
  pts->InsertPoint(14,this->Points->GetPoint(7));

  ptIds->InsertId(15,this->PointIds->GetId(4));
  ptIds->InsertId(16,this->PointIds->GetId(8));
  ptIds->InsertId(17,this->PointIds->GetId(5));
  pts->InsertPoint(15,this->Points->GetPoint(4));
  pts->InsertPoint(16,this->Points->GetPoint(8));
  pts->InsertPoint(17,this->Points->GetPoint(5));

  ptIds->InsertId(18,this->PointIds->GetId(5));
  ptIds->InsertId(19,this->PointIds->GetId(8));
  ptIds->InsertId(20,this->PointIds->GetId(6));
  pts->InsertPoint(18,this->Points->GetPoint(5));
  pts->InsertPoint(19,this->Points->GetPoint(8));
  pts->InsertPoint(20,this->Points->GetPoint(6));

  ptIds->InsertId(21,this->PointIds->GetId(6));
  ptIds->InsertId(22,this->PointIds->GetId(8));
  ptIds->InsertId(23,this->PointIds->GetId(7));
  pts->InsertPoint(21,this->Points->GetPoint(6));
  pts->InsertPoint(22,this->Points->GetPoint(8));
  pts->InsertPoint(23,this->Points->GetPoint(7));

  return 1;
}

//----------------------------------------------------------------------------
void
vtkBiQuadraticQuad::Derivatives (int vtkNotUsed (subId),
                                 double pcoords[3], double *values,
                                 int dim, double *derivs)
{
  double x0[3], x1[3], x2[3], deltaX[3], weights[9];
  int i, j;
  double functionDerivs[18];

  this->Points->GetPoint (0, x0);
  this->Points->GetPoint (1, x1);
  this->Points->GetPoint (2, x2);

  this->InterpolationFunctions (pcoords, weights);
  this->InterpolationDerivs (pcoords, functionDerivs);

  for (i = 0; i < 3; i++)
    {
    deltaX[i] = x1[i] - x0[i] - x2[i];
    }
  for (i = 0; i < dim; i++)
    {
    for (j = 0; j < 3; j++)
      {
      if (deltaX[j] != 0)
        {
        derivs[3 * i + j] = (values[2 * i + 1] - values[2 * i]) / deltaX[j];
        }
      else
        {
        derivs[3 * i + j] = 0;
        }
      }
    }
}



//----------------------------------------------------------------------------
// Compute interpolation functions. The first four nodes are the corner
// vertices; the others are mid-edge nodes, the last one is the mid-center
// node.
void vtkBiQuadraticQuad::InterpolationFunctions (double pcoords[3],
                                                 double weights[9])
{
  //VTK needs parametric coordinates to be between (0,1). Isoparametric
  //shape functions are normaly formulated between (-1,1). But because we need
  //to derivate these functions in x and y direction, we are formulating the
  //shape functions in parametric coordinates. Normaly these coordinates are
  //named r and s, but i choosed x and y, because you can easily mark and
  //paste these functions to the gnuplot splot function. :D
  double x = pcoords[0];
  double y = pcoords[1];

  //midedge weights
  weights[0] =  4.0 * (1.0 - x) * (x - 0.5) * (1.0 - y) * (y - 0.5);
  weights[1] = -4.0 *       (x) * (x - 0.5) * (1.0 - y) * (y - 0.5);
  weights[2] =  4.0 *       (x) * (x - 0.5) *       (y) * (y - 0.5);
  weights[3] = -4.0 * (1.0 - x) * (x - 0.5) *       (y) * (y - 0.5);
  //corner
  weights[4] =  8.0 *       (x) * (1.0 - x) * (1.0 - y) * (0.5 - y);
  weights[5] = -8.0 *       (x) * (0.5 - x) * (1.0 - y) * (y);
  weights[6] = -8.0 *       (x) * (1.0 - x) *       (y) * (0.5 - y);
  weights[7] =  8.0 * (1.0 - x) * (0.5 - x) * (1.0 - y) * (y);
  //surface center weights
  weights[8] = 16.0 *       (x) * (1.0 - x) * (1.0 - y) * (y);
}

//----------------------------------------------------------------------------
// Derivatives in parametric space.
void vtkBiQuadraticQuad::InterpolationDerivs (double pcoords[3], double derivs[18])
{
  // Coordinate conversion
  double x = pcoords[0];
  double y = pcoords[1];

  // Derivatives in the x-direction
  // edge
  derivs[0] = 4.0 * (1.5 - 2.0 * x) * (1.0 - y) * (y - 0.5);
  derivs[1] =-4.0 * (2.0 * x - 0.5) * (1.0 - y) * (y - 0.5);
  derivs[2] = 4.0 * (2.0 * x - 0.5) *       (y) * (y - 0.5);
  derivs[3] =-4.0 * (1.5 - 2.0 * x) *       (y) * (y - 0.5);
  // midedge
  derivs[4] = 8.0 * (1.0 - 2.0 * x) * (1.0 - y) * (0.5 - y);
  derivs[5] =-8.0 * (0.5 - 2.0 * x) * (1.0 - y) * (y);
  derivs[6] =-8.0 * (1.0 - 2.0 * x) *       (y) * (0.5 - y);
  derivs[7] = 8.0 * (2.0 * x - 1.5) * (1.0 - y) * (y);
  // center
  derivs[8] =16.0 * (1.0 - 2.0 * x) * (1.0 - y) * (y);

  // Derivatives in the y-direction
  // edge
  derivs[9] = 4.0 * (1.0 - x) * (x - 0.5) * (1.5 - 2.0 * y);
  derivs[10]=-4.0 *       (x) * (x - 0.5) * (1.5 - 2.0 * y);
  derivs[11]= 4.0 *       (x) * (x - 0.5) * (2.0 * y - 0.5);
  derivs[12]=-4.0 * (1.0 - x) * (x - 0.5) * (2.0 * y - 0.5);
  // midedge
  derivs[13]= 8.0 *       (x) * (1.0 - x) * (1.5 + 2.0 * y);
  derivs[14]=-8.0 *       (x) * (0.5 - x) * (1.0 - 2.0 * y);
  derivs[15]=-8.0 *       (x) * (1.0 - x) * (0.5 - 2.0 * y);
  derivs[16]= 8.0 * (1.0 - x) * (0.5 - x) * (1.0 - 2.0 * y);
  // center
  derivs[17]=16.0 *       (x) * (1.0 - x) * (1.0 - 2.0 * y);

}

//----------------------------------------------------------------------------
static double vtkQQuadCellPCoords[27] = { 0.0, 0.0, 0.0, 1.0, 0.0, 0.0,
                                          1.0, 1.0, 0.0, 0.0, 1.0, 0.0,
                                          0.5, 0.0, 0.0, 1.0, 0.5, 0.0,
                                          0.5, 1.0, 0.0, 0.0, 0.5, 0.0,
                                          0.5, 0.5, 0.0 };

double * vtkBiQuadraticQuad::GetParametricCoords ()
{
  return vtkQQuadCellPCoords;
}

//----------------------------------------------------------------------------
void vtkBiQuadraticQuad::PrintSelf(ostream & os, vtkIndent indent)
{
  this->Superclass::PrintSelf(os, indent);

  os << indent << "Edge:\n";
  this->Edge->PrintSelf (os, indent.GetNextIndent ());
  os << indent << "Quad:\n";
  this->Quad->PrintSelf (os, indent.GetNextIndent ());
  os << indent << "Scalars:\n";
  this->Scalars->PrintSelf (os, indent.GetNextIndent ());
}
