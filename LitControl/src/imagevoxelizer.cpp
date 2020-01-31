#include <iostream>
#include "include/imagevoxelizer.h"
#include "include/voxelizer.h"


void ImageVoxelizer::voxelize(std::string filename, int center, int resize){
    ObjReader *objr = new ObjReader(filename);
    if(center == 2){
        std::cerr << "center" << std::endl;
        objr->center(objr->getCenterVector());
    }
    if(resize == 2){
        std::cerr << "resize" << std::endl;
        std::cout << objr->getResizeFactor() << std::endl;
        objr->resize(objr->getResizeFactor());
    }
    objr->getFacesFromFile();
    Voxelizer::voxelize(objr->getFaces(), objr->getColors(), filename + ".ppm");
}

