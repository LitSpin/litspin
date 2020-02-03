#ifndef OBJREADER_H
#define OBJREADER_H

#include <string>
#include <array>
#include <vector>
#include <map>
#include "vector3d.h"
#include "face.h"

// obj and mtl file parser
class ObjReader {

private:
  const std::string filename;
  std::vector<Vector3D> vectors;
  std::vector<Face> faces;
  std::map<std::string, std::vector<double>> colors;

public:
  ObjReader(std::string fname);
  std::vector<Face> getFaces();
  std::string getPath(){return filename;}
  std::pair<Vector3D, Vector3D> getExtremes();
  Vector3D getCenterVector();
  double getResizeFactor();
  void center(Vector3D center_vector);
  void resize(double resize_factor);
  void getFacesFromFile();
  std::map<std::string, std::vector<double>> getColors();

};

#endif //OBJREADER_H
