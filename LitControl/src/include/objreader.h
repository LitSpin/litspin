#ifndef OBJREADER_H
#define OBJREADER_H

#include<string>
#include<array>
#include<vector>
#include<map>

#include"vector3d.h"
#include"face.h"

// obj and mtl file parser
class ObjReader {

private:
  std::string filename;
  std::vector<Face> faces;
  std::map<std::string, std::vector<double>> colors;

public:
  ObjReader(std::string fname);
  std::vector<Face> getFaces();
  std::map<std::string, std::vector<double>> getColors();

};

#endif //OBJREADER_H
