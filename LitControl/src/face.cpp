#include<vector>
#include "include/face.h"

Face::Face(std::vector<Vector3D> angles, std::string mtl) : m_angles(angles), m_mtl(mtl) {}

std::vector<Vector3D> Face::getAngles() {
  return m_angles;
}

std::string Face::getMtl() {
  return m_mtl;
}

void Face::display(){
    for(auto angle : m_angles){
        angle.display();
    }
}
