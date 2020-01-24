#ifndef VOXELIZER_H
#define VOXELIZER_H
#include "vector3d.h"

using namespace std;

class Voxelizer{

  public :
    static void voxelize(string fileName);

  private :
    static bool RayIntersectsTriangle(Vector3D rayOrigin,
                               Vector3D rayVector,
                               Vector3D p0,
                               Vector3D p1,
                               Vector3D p2,
                               Vector3D& outIntersectionPoint);
};

#endif
