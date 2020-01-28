#ifndef FACE_H
#define FACE_H

#include <vector>
#include <string>

#include "vector3d.h"

// representation of a face with its associated texture
class Face {
private:
  std::vector<Vector3D> m_angles;
  std::string m_mtl;

public:
  Face(std::vector<Vector3D> angles, std::string mtl);
  std::vector<Vector3D> getAngles();
  std::string getMtl();
  void display();

};

#endif //FACE_H
