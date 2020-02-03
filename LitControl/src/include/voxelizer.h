#ifndef VOXELIZER_H
#define VOXELIZER_H

#include <string>
#include <map>
#include "vector3d.h"
#include "face.h"

class Voxelizer{

public:
    static int voxelize(std::vector<Face> faces, std::map<std::string, std::vector<double>> obj_colors, std::string outputFile);
private :
    static bool RayIntersectsTriangle(const Vector3D &rayOrigin,
                                      const Vector3D &rayVector,
                                      const Vector3D &p0,
                                      const Vector3D &p1,
                                      const Vector3D &p2,
                                      Vector3D& outIntersectionPoint);
};

#endif
