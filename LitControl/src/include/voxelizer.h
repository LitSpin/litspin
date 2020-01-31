#ifndef VOXELIZER_H
#define VOXELIZER_H

#include <string>

#include "vector3d.h"

class Voxelizer{

  public :
    static void voxelize(std::string fileName);

  private :
    static bool RayIntersectsTriangle(const Vector3D &rayOrigin,
                               const Vector3D &rayVector,
                               const Vector3D &p0,
                               const Vector3D &p1,
                               const Vector3D &p2,
                               Vector3D& outIntersectionPoint);
};

#endif
