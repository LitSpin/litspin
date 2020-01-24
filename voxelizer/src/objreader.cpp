#include <fstream>
#include <iostream>
#include <sstream>
#include "include/objreader.h"

ObjReader::ObjReader(std::string fname): filename(fname) {
  // parsing of obj file
  std::ifstream infile ("data/"+filename+".obj");
  if (infile.is_open()) {
    std::cout << "début du obj" << std::endl;
    // line currently processed
    std::string line;
    // list of every vertex (so that they can be accessed easily)
    std::vector<std::string> vertex;
    // to link the material to the face number
    std::string mtl_name;
    while (std::getline(infile, line)) {
      if (line[0]=='v') {
        vertex.push_back(line);
      }
      else if (line.substr(0,6)=="usemtl") {
        std::cout << "material found in obj file" << std::endl;
        std::size_t found = line.find_first_of(" ");
        mtl_name = line.substr(found+1,std::string::npos);
        std::cout << "mtl_name: " << mtl_name << std::endl;
      }
      else if (line[0]=='f') {
        std::size_t found = line.find_last_of(" ");
        // list of the 3 Vertex3D objects that define the face
        std::vector<Vector3D> coord;
        // list of file lines where to find the vertex coordinates
        std::vector<int> indices;
        std::size_t next = line.size();
        while (found!=std::string::npos) {
          indices.push_back(stoi(line.substr(found+1, next-found-1)));
          next = found;
          found = line.find_last_of(" ", next-1);
        }
        for (auto it = indices.begin(); it != indices.end(); it++) {
          // vertex line currently parsed (indices in obj file start at 1)
          std::string v_line = vertex[*it-1];
          // list of coordinates in the v line
          std::vector<double> v_coor;
          next = v_line.size();
          found = v_line.find_last_of(" ");
          while (found!=std::string::npos) {
            v_coor.push_back(stod(v_line.substr(found+1, next-found-1)));
            next = found;
            found = v_line.find_last_of(" ", next-1);
          }
          coord.push_back(Vector3D(v_coor[2],v_coor[1],v_coor[0]));
        }
        faces.push_back(Face(coord, mtl_name));
      }
    }
  }
  else {
    std::cout << "obj file cannot be opened" <<  std::endl;
  }
  infile.close();
  std::cout << "nombre de faces: " << faces.size() << std::endl;
  //parsing of mtl file
  infile.open("data/"+filename+".mtl");
  if (infile.is_open()) {
    std::cout << "début du mtl" << std::endl;
    std::string line;
    std::string mtl_name;
    while (std::getline(infile, line)) {
      if (line.substr(0,6) == "newmtl") {
        std::cout << "new material" << std::endl;
        std::size_t found = line.find_first_of(" ");
        mtl_name = line.substr(found+1,std::string::npos);
        std::cout << "with mtl name: " << mtl_name << std::endl;
      }
      else if (line.substr(0,2) == "Kd") {
        std::cout << "found Kd color" << std::endl;
        //get the RGB components
        std::size_t found = line.find_last_of(" ");
        // list of the rgb values
        std::vector<double> rgb;
        std::size_t next = line.size();
        while (found!=std::string::npos) {
          std::cout << line.substr(found+1, next-found-1) << std::endl;
          rgb.insert(rgb.begin(), stod(line.substr(found+1, next-found-1)));
          next = found;
          found = line.find_last_of(" ", next-1);
        }
        std::cout << "adding to color table" << std::endl;
        std::cout << "with mtl name: " << mtl_name << std::endl;
        colors[mtl_name] = rgb;
      }
    }
  }
  else {
    std::cout << "mtl file cannot be opened" <<  std::endl;
  }
  std::cout << "nb of mtl: " << colors.size() << std::endl;
  for (auto it=colors.begin(); it!= colors.end(); it++) {
    std::cout << it->first << " " << it->second[0] << std::endl;
  }
  infile.close();

}

std::vector<Face> ObjReader::getFaces() {
  return faces;
}

std::map<std::string, std::vector<double>> ObjReader::getColors() {
  return colors;
}
