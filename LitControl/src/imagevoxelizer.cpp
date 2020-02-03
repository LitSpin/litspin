#include <iostream>
#include "include/imagevoxelizer.h"
#include "include/voxelizer.h"


int ImageVoxelizer::voxelize(std::string filename, int center, int resize){
    ObjReader *objr = new ObjReader(filename);
    if(center == 2){
        objr->center(objr->getCenterVector());
    }
    if(resize == 2){

        objr->resize(objr->getResizeFactor());
    }
    objr->getFacesFromFile();

    return Voxelizer::voxelize(objr->getFaces(), objr->getColors(), filename + ".ppm");
}

