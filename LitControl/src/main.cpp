#include <iostream>
#include <sstream>
#include <fstream>
#include <iostream>
#include <cmath>
#include <algorithm>
#include "include/vector3d.h"
#include "include/objreader.h"
#include "include/face.h"
#include "include/voxelizer.h"

#define NB_CIRCLES 20
#define ANG_SUBDIVISIONS 128
#define HEIGHT 0.10
#define RADIUS 0.12

#define PI 3.14159

int main (int argc, char *argv[]) {
  if(argc != 2)
    std::cerr << "wrong number of inputs. expected file name without extension" << std::endl;
  string fileName = argv[1];
  Voxelizer::voxelize(fileName);
  return 0;
}
